local Tree = require("which-key.tree")
local Util = require("which-key.util")
local Config = require("which-key.config")

-- secret character that will be used to create <nop> mappings
local secret = "Þ"

---@class Keys
local M = {}

M.functions = {}
M.operators = {}
M.nowait = {}
M.blacklist = {}

function M.setup()
  local builtin_ops = require("which-key.plugins.presets").operators
  for op, _ in pairs(builtin_ops) do
    M.operators[op] = true
  end
  local mappings = {}
  for op, label in pairs(Config.options.operators) do
    M.operators[op] = true
    if builtin_ops[op] then
      mappings[op] = { name = label, i = { name = "inside" }, a = { name = "around" } }
    end
  end
  for _, t in pairs(Config.options.triggers_nowait) do
    M.nowait[t] = true
  end
  M.register(mappings, { mode = "n", preset = true })
  M.register({ i = { name = "inside" }, a = { name = "around" } }, { mode = "v", preset = true })
  for mode, blacklist in pairs(Config.options.triggers_blacklist) do
    for _, prefix_n in ipairs(blacklist) do
      M.blacklist[mode] = M.blacklist[mode] or {}
      M.blacklist[mode][prefix_n] = true
    end
  end
end

function M.get_operator(prefix_i)
  for op_n, _ in pairs(Config.options.operators) do
    local op_i = Util.t(op_n)
    if prefix_i:sub(1, #op_i) == op_i then
      return op_i, op_n
    end
  end
end

function M.process_motions(ret, mode, prefix_i, buf)
  local op_i, op_n = "", ""
  if mode ~= "v" then
    op_i, op_n = M.get_operator(prefix_i)
  end
  if (mode == "n" or mode == "v") and op_i then
    local op_prefix_i = prefix_i:sub(#op_i + 1)
    local op_count = op_prefix_i:match("^(%d+)")
    if op_count == "0" then
      op_count = nil
    end
    if Config.options.motions.count == false then
      op_count = nil
    end
    if op_count then
      op_prefix_i = op_prefix_i:sub(#op_count + 1)
    end
    local op_results = M.get_mappings("o", op_prefix_i, buf)

    if not ret.mapping and op_results.mapping then
      ret.mapping = op_results.mapping
      ret.mapping.prefix = op_n .. (op_count or "") .. ret.mapping.prefix
      ret.mapping.keys = Util.parse_keys(ret.mapping.prefix)
    end

    for _, mapping in pairs(op_results.mappings) do
      mapping.prefix = op_n .. (op_count or "") .. mapping.prefix
      mapping.keys = Util.parse_keys(mapping.prefix)
      table.insert(ret.mappings, mapping)
    end
  end
end

---@return MappingGroup
function M.get_mappings(mode, prefix_i, buf)
  ---@class MappingGroup
  ---@field mode string
  ---@field prefix_i string
  ---@field buf number
  ---@field mapping? Mapping
  ---@field mappings VisualMapping[]
  local ret
  ret = { mapping = nil, mappings = {}, mode = mode, buf = buf, prefix_i = prefix_i }

  local prefix_len = #Util.parse_internal(prefix_i)

  ---@param node? Node
  local function add(node)
    if node then
      if node.mapping then
        ret.mapping = vim.tbl_deep_extend("force", {}, ret.mapping or {}, node.mapping)
      end
      for k, child in pairs(node.children) do
        if
          child.mapping
          and child.mapping.label ~= "which_key_ignore"
          and child.mapping.desc ~= "which_key_ignore"
          and not (child.mapping.group and vim.tbl_isempty(child.children))
        then
          ret.mappings[k] = vim.tbl_deep_extend("force", {}, ret.mappings[k] or {}, child.mapping)
        end
      end
    end
  end

  local plugin_context = { buf = buf, mode = mode }
  add(M.get_tree(mode).tree:get(prefix_i, nil, plugin_context))
  add(M.get_tree(mode, buf).tree:get(prefix_i, nil, plugin_context))

  -- Handle motions
  M.process_motions(ret, mode, prefix_i, buf)

  -- Fix labels
  local tmp = {}
  for _, value in pairs(ret.mappings) do
    value.key = value.keys.notation[prefix_len + 1]
    if Config.options.key_labels[value.key] then
      value.key = Config.options.key_labels[value.key]
    end
    local skip = not value.label and Config.options.ignore_missing == true
    if Util.t(value.key) == Util.t("<esc>") then
      skip = true
    end
    if not skip then
      if value.group then
        value.label = value.label or "+prefix"
        value.label = value.label:gsub("^%+", "")
        value.label = Config.options.icons.group .. value.label
      elseif not value.label then
        value.label = value.desc or value.cmd or ""
        for _, v in ipairs(Config.options.hidden) do
          value.label = value.label:gsub(v, "")
        end
      end
      if value.value then
        value.value = vim.fn.strtrans(value.value)
      end
      -- remove duplicated keymap
      local exists = false
      for k, v in pairs(tmp) do
        if type(v) == "table" and v.key == value.key then
          tmp[k] = value
          exists = true
          break
        end
      end
      if not exists then
        table.insert(tmp, value)
      end
    end
  end

  -- Sort items, but not for plugins
  table.sort(tmp, function(a, b)
    if a.order and b.order then
      return a.order < b.order
    end
    if a.group == b.group then
      local ak = (a.key or ""):lower()
      local bk = (b.key or ""):lower()
      local aw = ak:match("[a-z]") and 1 or 0
      local bw = bk:match("[a-z]") and 1 or 0
      if aw == bw then
        return ak < bk
      end
      return aw < bw
    else
      return (a.group and 1 or 0) < (b.group and 1 or 0)
    end
  end)
  ret.mappings = tmp

  return ret
end

---@type table<string, MappingTree>
M.mappings = {}
M.duplicates = {}

function M.map(mode, prefix_n, cmd, buf, opts)
  local other = vim.api.nvim_buf_call(buf or 0, function()
    local ret = vim.fn.maparg(prefix_n, mode, false, true)
    ---@diagnostic disable-next-line: undefined-field
    return (ret and ret.lhs and ret.rhs and ret.rhs ~= cmd) and ret or nil
  end)
  if other and other.buffer == buf then
    table.insert(M.duplicates, { mode = mode, prefix = prefix_n, cmd = cmd, buf = buf, other = other })
  end
  if buf ~= nil then
    pcall(vim.api.nvim_buf_set_keymap, buf, mode, prefix_n, cmd, opts)
  else
    pcall(vim.api.nvim_set_keymap, mode, prefix_n, cmd, opts)
  end
end

function M.register(mappings, opts)
  opts = opts or {}

  mappings = require("which-key.mappings").parse(mappings, opts)

  -- always create the root node for the mode, even if there's no mappings,
  -- to ensure we have at least a trigger hooked for non documented keymaps
  local modes = {}

  for _, mapping in pairs(mappings) do
    if not modes[mapping.mode] then
      modes[mapping.mode] = true
      M.get_tree(mapping.mode)
    end
    if mapping.cmd ~= nil then
      M.map(mapping.mode, mapping.prefix, mapping.cmd, mapping.buf, mapping.opts)
    end
    M.get_tree(mapping.mode, mapping.buf).tree:add(mapping)
  end
end

M.hooked = {}

function M.hook_id(prefix_n, mode, buf)
  return mode .. (buf or "") .. Util.t(prefix_n)
end

function M.is_hooked(prefix_n, mode, buf)
  return M.hooked[M.hook_id(prefix_n, mode, buf)]
end

function M.hook_del(prefix_n, mode, buf)
  local id = M.hook_id(prefix_n, mode, buf)
  M.hooked[id] = nil
  if buf then
    pcall(vim.api.nvim_buf_del_keymap, buf, mode, prefix_n)
    pcall(vim.api.nvim_buf_del_keymap, buf, mode, prefix_n .. secret)
  else
    pcall(vim.api.nvim_del_keymap, mode, prefix_n)
    pcall(vim.api.nvim_del_keymap, mode, prefix_n .. secret)
  end
end

function M.hook_add(prefix_n, mode, buf, secret_only)
  -- check if this trigger is blacklisted
  if M.blacklist[mode] and M.blacklist[mode][prefix_n] then
    return
  end
  -- don't hook numbers. See #118
  if tonumber(prefix_n) then
    return
  end
  -- don't hook to j or k in INSERT mode
  if mode == "i" and (prefix_n == "j" or prefix_n == "k") then
    return
  end
  -- never hook q
  if mode == "n" and prefix_n == "q" then
    return
  end
  -- never hook into select mode
  if mode == "s" then
    return
  end
  -- never hook into operator pending mode
  -- this is handled differently
  if mode == "o" then
    return
  end
  if Util.t(prefix_n) == Util.t("<esc>") then
    return
  end
  -- never hook into operators in visual mode
  if (mode == "v" or mode == "x") and (prefix_n == "a" or prefix_n == "i" or M.operators[prefix_n]) then
    return
  end

  -- Check if we need to create the hook
  if type(Config.options.triggers) == "string" and Config.options.triggers ~= "auto" then
    if Util.t(prefix_n) ~= Util.t(Config.options.triggers) then
      return
    end
  end
  if type(Config.options.triggers) == "table" then
    local ok = false
    for _, trigger in pairs(Config.options.triggers) do
      if Util.t(trigger) == Util.t(prefix_n) then
        ok = true
        break
      end
    end
    if not ok then
      return
    end
  end

  local opts = { noremap = true, silent = true }
  local id = M.hook_id(prefix_n, mode, buf)
  local id_global = M.hook_id(prefix_n, mode)
  -- hook up if needed
  if not M.hooked[id] and not M.hooked[id_global] then
    local cmd = [[<cmd>lua require("which-key").show(%q, {mode = %q, auto = true})<cr>]]
    cmd = string.format(cmd, Util.t(prefix_n), mode)
    -- map group triggers and nops
    -- nops are needed, so that WhichKey always respects timeoutlen

    local mapmode = mode == "v" and "x" or mode
    if secret_only ~= true then
      M.map(mapmode, prefix_n, cmd, buf, opts)
    end
    if not M.nowait[prefix_n] then
      M.map(mapmode, prefix_n .. secret, "<nop>", buf, opts)
    end

    M.hooked[id] = true
  end
end

function M.update(buf)
  for k, tree in pairs(M.mappings) do
    if tree.buf and not vim.api.nvim_buf_is_valid(tree.buf) then
      -- remove group for invalid buffers
      M.mappings[k] = nil
    elseif not buf or not tree.buf or buf == tree.buf then
      -- only update buffer maps, if:
      -- 1. we dont pass a buffer
      -- 2. this is a global node
      -- 3. this is a local buffer node for the passed buffer
      M.update_keymaps(tree.mode, tree.buf)
      M.add_hooks(tree.mode, tree.buf, tree.tree.root)
    end
  end
end

---@param node Node
function M.add_hooks(mode, buf, node, secret_only)
  if not node.mapping then
    node.mapping = { prefix = node.prefix_n, group = true, keys = Util.parse_keys(node.prefix_n) }
  end
  if node.prefix_n ~= "" and node.mapping.group == true and not (node.mapping.cmd or node.mapping.callback) then
    -- first non-cmd level, so create hook and make all decendents secret only
    M.hook_add(node.prefix_n, mode, buf, secret_only)
    secret_only = true
  end
  for _, child in pairs(node.children) do
    M.add_hooks(mode, buf, child, secret_only)
  end
end

function M.dump()
  local ok = {}
  local todo = {}
  for _, tree in pairs(M.mappings) do
    M.update_keymaps(tree.mode, tree.buf)
    tree.tree:walk(
      ---@param node Node
      function(node)
        if node.mapping then
          if node.mapping.label then
            ok[node.mapping.prefix] = true
            todo[node.mapping.prefix] = nil
          elseif not ok[node.mapping.prefix] then
            todo[node.mapping.prefix] = { node.mapping.cmd or "" }
          end
        end
      end
    )
  end
  return todo
end

---@param mode string
---@param buf? buffer
function M.get_tree(mode, buf)
  if mode == "s" or mode == "x" then
    mode = "v"
  end
  Util.check_mode(mode, buf)
  local idx = mode .. (buf or "")
  if not M.mappings[idx] then
    M.mappings[idx] = { mode = mode, buf = buf, tree = Tree:new() }
  end
  return M.mappings[idx]
end

---@param prefix string
---@param cmd string?
function M.is_hook(prefix, cmd)
  -- skip mappings with our secret nop command
  if prefix:find(secret, 1, true) then
    return true
  end
  -- skip auto which-key mappings
  return cmd and cmd:find("which-key", 1, true) and cmd:find("auto", 1, true)
end

---@param mode string
---@param buf? number
function M.update_keymaps(mode, buf)
  ---@type Keymap[]
  local keymaps = buf and vim.api.nvim_buf_get_keymap(buf, mode) or vim.api.nvim_get_keymap(mode)
  local tree = M.get_tree(mode, buf).tree

  local function is_nop(keymap)
    return not keymap.callback and (keymap.rhs == "" or keymap.rhs:lower() == "<nop>")
  end

  for _, keymap in pairs(keymaps) do
    local skip = M.is_hook(keymap.lhs, keymap.rhs)

    if is_nop(keymap) then
      skip = true
    end

    if not skip then
      local mapping = {
        prefix = keymap.lhs,
        cmd = keymap.rhs,
        desc = keymap.desc,
        callback = keymap.callback,
        keys = Util.parse_keys(keymap.lhs),
      }
      -- don't include Plug keymaps
      if mapping.keys.notation[1]:lower() ~= "<plug>" then
        local node = tree:add(mapping)
        if node.mapping and node.mapping.preset and mapping.desc then
          node.mapping.label = mapping.desc
        end
      end
    end
  end
end

return M
