local Tree = require("which-key.tree")
local Util = require("which-key.util")
local Config = require("which-key.config")

-- secret character that will be used to create <nop> mappings
local secret = "Þ"

local M = {}

function M.setup()
  local mappings = {}
  for op, label in pairs(Config.options.operators) do mappings[op] = { name = label } end
  M.register(mappings, { mode = "n" })
  M.register({ i = { name = "inside" }, a = { name = "around" } }, { mode = "v" })
end

function M.get_operator(prefix)
  for op, _ in pairs(Config.options.operators) do if prefix:sub(1, #op) == op then return op end end
end

---@return MappingGroup
function M.get_mappings(mode, prefix, buf)
  ---@class MappingGroup
  ---@field mode string
  ---@field prefix string
  ---@field buf number
  ---@field mapping Mapping
  ---@field mappings VisualMapping[]
  local ret
  ret = { mapping = nil, mappings = {}, mode = mode, buf = buf, prefix = prefix }

  local prefix_len = #Util.parse_keys(prefix).nvim

  ---@param node Node
  local function add(node)
    if node then
      if node.mapping then
        ret.mapping = vim.tbl_deep_extend("force", {}, ret.mapping or {}, node.mapping)
      end
      for k, child in pairs(node.children) do
        if child.mapping and child.mapping.label ~= "which_key_ignore" then
          ret.mappings[k] = vim.tbl_deep_extend("force", {}, ret.mappings[k] or {}, child.mapping)
        end
      end
    end
  end

  add(M.get_tree(mode).tree:get(prefix))
  add(M.get_tree(mode, buf).tree:get(prefix))

  if ret.mapping and ret.mapping.plugin then require("which-key.plugins").invoke(ret) end

  local operator = M.get_operator(prefix)
  if mode == "v" then operator = "" end
  if (mode == "n" or mode == "v") and operator then
    local op_prefix = prefix:sub(#operator + 1)
    local op_results = M.get_mappings("o", op_prefix, buf)
    if not ret.mapping and op_results.mapping then
      ret.mapping = op_results.mapping
      ret.mapping.prefix = prefix
    end
    for _, mapping in pairs(op_results.mappings) do
      mapping.prefix = operator .. mapping.prefix
      mapping.keys = Util.parse_keys(mapping.prefix)
      table.insert(ret.mappings, mapping)
    end
  end

  local tmp = {}
  for _, value in pairs(ret.mappings) do
    value.key = value.keys.nvim[prefix_len + 1]
    if value.group then
      value.label = value.label or "+prefix"
      value.label = value.label:gsub("^%+", "")
      value.label = Config.options.icons.group .. value.label
    else
      if not value.label then
        value.label = value.cmd or ""
        for _, v in ipairs(Config.options.hidden) do value.label = value.label:gsub(v, "") end
      end
    end
    table.insert(tmp, value)
  end

  if not ret.mapping or not ret.mapping.plugin then
    table.sort(tmp, function(a, b)
      if a.group == b.group then
        return (a.key or "") < (b.key or "")
      else
        return (a.group and 1 or 0) < (b.group and 1 or 0)
      end
    end)
  end
  ret.mappings = tmp
  return ret
end

---@param mappings Mapping[]
---@return Mapping[]
function M.parse_mappings(mappings, value, prefix)
  prefix = prefix or ""
  if type(value) == "string" then
    table.insert(mappings, { prefix = prefix, label = value })
  elseif type(value) == "table" then
    if #value == 0 then
      -- key group
      for k, v in pairs(value) do
        if k ~= "name" then M.parse_mappings(mappings, v, prefix .. k) end
      end
      if prefix ~= "" then
        if value.name then value.name = value.name:gsub("^%+", "") end
        table.insert(mappings, { prefix = prefix, label = value.name, group = true })
      end
    else
      -- key mapping
      ---@type Mapping
      local mapping
      mapping = { prefix = prefix, opts = {}, buf = M.get_buf_option(value) }
      for k, v in pairs(value) do
        if k == 1 then
          mapping.label = v
        elseif k == 2 then
          mapping.cmd = mapping.label
          mapping.label = v
        elseif k == "noremap" then
          mapping.opts.noremap = v
        elseif k == "silent" then
          mapping.opts.silent = v
        elseif k == "plugin" then
          mapping.group = true
          mapping.plugin = v
        else
          error("Invalid key mapping: " .. vim.inspect(value))
        end
      end
      table.insert(mappings, mapping)
    end
  else
    error("Invalid mapping " .. vim.inspect(value))
  end
  return mappings
end

function M.get_buf_option(opts)
  for _, k in pairs({ "buffer", "bufnr", "buf" }) do
    if opts[k] then
      local v = opts[k]
      opts[k] = nil
      if k == "buffer" then
        return v
      elseif k == "bufnr" or k == "buf" then
        Util.warn(string.format([[please use "buffer" instead of %q for buffer mappings]], k))
        return v
      end
    end
  end
end

---@type table<string, MappingTree>
M.mappings = {}

function M.register(mappings, opts)
  opts = opts or {}

  local prefix = opts.prefix or ""
  local mode = opts.mode or "n"

  opts.buffer = M.get_buf_option(opts)

  mappings = M.parse_mappings({}, mappings, prefix)

  -- always create the root node for the mode, even if there's no mappings,
  -- to ensure we have at least a trigger hooked for non documented keymaps
  M.get_tree(mode)

  for _, mapping in pairs(mappings) do
    if opts.buffer and not mapping.buf then mapping.buf = opts.buffer end
    mapping.keys = Util.parse_keys(mapping.prefix)
    if mapping.cmd then
      mapping.opts = vim.tbl_deep_extend("force", { silent = true, noremap = true }, opts,
                                         mapping.opts or {})
      local keymap_opts = {
        silent = mapping.opts.silent,
        noremap = mapping.opts.noremap,
        nowait = mapping.opts.nowait or false,
      }
      if mapping.buf ~= nil then
        vim.api.nvim_buf_set_keymap(mapping.buf, mode, mapping.prefix, mapping.cmd, keymap_opts)
      else
        vim.api.nvim_set_keymap(mode, mapping.prefix, mapping.cmd, keymap_opts)
      end
    end
    M.get_tree(mode, mapping.buf).tree:add(mapping)
  end
  M.update()
end

M.hooked = {}

function M.hook_id(prefix, mode, buf) return mode .. (buf or "") .. prefix end

function M.hook_del(prefix, mode, buf)
  local id = M.hook_id(prefix, mode, buf)
  M.hooked[id] = nil
  if buf then
    pcall(vim.api.nvim_buf_del_keymap, buf, mode, prefix)
    pcall(vim.api.nvim_buf_del_keymap, buf, mode, prefix .. secret)
  else
    pcall(vim.api.nvim_del_keymap, mode, prefix)
    pcall(vim.api.nvim_del_keymap, mode, prefix .. secret)
  end
end

function M.hook_add(prefix, mode, buf)
  -- never hook into operator pending mode
  -- this is handled differently
  if mode == "o" then return end

  local opts = { noremap = true, silent = true }
  local id = M.hook_id(prefix, mode, buf)
  -- hook up if needed
  if not M.hooked[id] then
    local cmd = [[<cmd>lua require("which-key").show(%q, {mode = %q, auto = true})<cr>]]
    cmd = string.format(cmd, prefix, mode)
    -- map group triggers and nops
    -- nops are needed, so that WhichKey always respects timeoutlen
    if buf then
      vim.api.nvim_buf_set_keymap(buf, mode, prefix, cmd, opts)
      vim.api.nvim_buf_set_keymap(buf, mode, prefix .. secret, "<nop>", opts)
    else
      vim.api.nvim_set_keymap(mode, prefix, cmd, opts)
      vim.api.nvim_set_keymap(mode, prefix .. secret, "<nop>", opts)
    end
    M.hooked[id] = true
  end
end

function M.update(buf)
  for k, tree in pairs(M.mappings) do
    if tree.buf and not vim.api.nvim_buf_is_valid(tree.buf) then
      -- remove group for invalid buffers
      M.mappings[k] = nil
    elseif (not buf) or (not tree.buf) or buf == tree.buf then
      -- only update buffer maps, if:
      -- 1. we dont pass a buffer
      -- 2. this is a global node
      -- 3. this is a local buffer node for the passed buffer
      M.update_keymaps(tree.mode, tree.buf)
      tree.tree:walk( ---@param node Node
      function(node)
        -- create group mapping if needed
        if not node.mapping then
          node.mapping = { prefix = node.prefix, group = true, keys = Util.parse_keys(node.prefix) }
        end
        if node.prefix ~= "" and node.mapping.group == true and not node.mapping.cmd then
          M.hook_add(node.prefix, tree.mode, tree.buf)
        end
      end)
    end
  end
end

function M.get_tree(mode, buf)
  Util.check_mode(mode, buf)
  local idx = mode .. (buf or "")
  if not M.mappings[idx] then M.mappings[idx] = { mode = mode, buf = buf, tree = Tree:new() } end
  return M.mappings[idx]
end

---@param mode string
---@param buf number
function M.update_keymaps(mode, buf)
  ---@type Keymap
  local keymaps = buf and vim.api.nvim_buf_get_keymap(buf, mode) or vim.api.nvim_get_keymap(mode)
  local tree = M.get_tree(mode, buf).tree
  for _, keymap in pairs(keymaps) do
    -- skip mappings with our secret nop command
    local has_secret = keymap.lhs:find(secret)
    -- skip auto which-key mappings
    local has_wk = keymap.rhs:find("which%-key") and keymap.rhs:find("auto")
    if not (has_secret or has_wk) then
      local mapping = {
        id = Util.t(keymap.lhs),
        prefix = keymap.lhs,
        cmd = keymap.rhs,
        keys = Util.parse_keys(keymap.lhs),
      }
      -- don't include Plug keymaps
      if mapping.keys.nvim[1]:lower() ~= "<plug>" then tree:add(mapping) end
    end
  end
end

return M
