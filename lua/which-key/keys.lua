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
  ---@field mapping Mapping
  ---@field mappings VisualMapping[]
  local ret
  ret = { mapping = nil, mappings = {}, mode = mode, buf = buf, prefix_i = prefix_i }

  local prefix_len = #Util.parse_internal(prefix_i)

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
      table.insert(tmp, value)
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

---@param mappings Mapping[]
---@return Mapping[]
function M.parse_mappings(mappings, value, prefix_n)
  prefix_n = prefix_n or ""
  if type(value) == "string" then
    table.insert(mappings, { prefix = prefix_n, label = value })
  elseif type(value) == "table" then
    if #value == 0 then
      -- key group
      for k, v in pairs(value) do
        if k ~= "name" then
          M.parse_mappings(mappings, v, prefix_n .. k)
        end
      end
      if prefix_n ~= "" then
        if value.name then
          value.name = value.name:gsub("^%+", "")
        end
        table.insert(mappings, { prefix = prefix_n, label = value.name, group = true })
      end
    else
      -- key mapping
      ---@type Mapping
      local mapping
      mapping = { prefix = prefix_n, opts = {}, buf = M.get_buf_option(value) }
      for k, v in pairs(value) do
        if k == 1 then
          mapping.label = v
        elseif k == 2 then
          mapping.cmd = value[1]
          mapping.label = v
        elseif k == "noremap" then
          mapping.opts.noremap = v
        elseif k == "silent" then
          mapping.opts.silent = v
        elseif k == "mode" then
          mapping.mode = v
        elseif k == "expr" then
          mapping.opts.expr = v
        elseif k == "plugin" then
          mapping.group = true
          mapping.plugin = v
        else
          error("Invalid key mapping: " .. vim.inspect(value))
        end
      end
      if mapping.cmd and type(mapping.cmd) == "function" then
        table.insert(M.functions, mapping.cmd)
        if mapping.opts.expr then
          mapping.cmd = string.format([[luaeval('require("which-key").execute(%d)')]], #M.functions)
        else
          mapping.cmd = string.format([[<cmd>lua require("which-key").execute(%d)<cr>]], #M.functions)
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
      if v == 0 then
        v = vim.api.nvim_get_current_buf()
      end
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
M.duplicates = {}

function M.map(mode, prefix_n, cmd, buf, opts)
  local other = vim.api.nvim_buf_call(buf or 0, function()
    local ret = vim.fn.maparg(prefix_n, mode, false, true)
    ---@diagnostic disable-next-line: undefined-field
    return (ret and ret.lhs and ret.rhs ~= cmd) and ret or nil
  end)
  if other then
    table.insert(M.duplicates, { mode = mode, prefix = prefix_n, cmd = cmd, buf = buf, other = other })
  end
  cmd = cmd:gsub("[\\]", "<bslash>")
  if buf ~= nil then
    pcall(vim.api.nvim_buf_set_keymap, buf, mode, prefix_n, cmd, opts)
  else
    pcall(vim.api.nvim_set_keymap, mode, prefix_n, cmd, opts)
  end
end

function M.register(mappings, opts)
  opts = opts or {}

  local prefix_n = opts.prefix or ""
  local mode = opts.mode or "n"

  opts.buffer = M.get_buf_option(opts)

  mappings = M.parse_mappings({}, mappings, prefix_n)

  -- always create the root node for the mode, even if there's no mappings,
  -- to ensure we have at least a trigger hooked for non documented keymaps
  M.get_tree(mode)

  for _, mapping in pairs(mappings) do
    if opts.buffer and not mapping.buf then
      mapping.buf = opts.buffer
    end
    if opts.preset then
      mapping.preset = true
    end
    mapping.keys = Util.parse_keys(mapping.prefix)
    mapping.mode = mapping.mode or mode
    if mapping.cmd then
      mapping.opts = vim.tbl_deep_extend("force", { silent = true, noremap = true }, opts, mapping.opts or {})
      local keymap_opts = {
        silent = mapping.opts.silent,
        noremap = mapping.opts.noremap,
        nowait = mapping.opts.nowait or false,
        expr = mapping.opts.expr or false,
      }
      if mapping.cmd:lower():sub(1, #"<plug>") == "<plug>" then
        keymap_opts.noremap = false
      end
      M.map(mapping.mode, mapping.prefix, mapping.cmd, mapping.buf, keymap_opts)
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
  if (mode == "v" or mode == "x") and M.operators[prefix_n] then
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
    if vim.g.mapleader == "\\" or vim.g.mapleader == nil then
      prefix_n = prefix_n:gsub("<[lL]eader>", "\\")
    end
    if vim.g.maplocalleader == "\\" or vim.g.maplocalleader == nil then
      prefix_n = prefix_n:gsub("<[lL]ocalleader>", "\\")
    end
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
  if node.prefix_n ~= "" and node.mapping.group == true and not node.mapping.cmd then
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
    tree.tree:walk( ---@param node Node
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

function M.check_health()
  vim.fn["health#report_start"]("WhichKey: checking conflicting keymaps")
  for _, tree in pairs(M.mappings) do
    M.update_keymaps(tree.mode, tree.buf)
    tree.tree:walk( ---@param node Node
      function(node)
        local count = 0
        for _ in pairs(node.children) do
          count = count + 1
        end

        local auto_prefix = not node.mapping or (node.mapping.group == true and not node.mapping.cmd)
        if node.prefix_i ~= "" and count > 0 and not auto_prefix then
          local msg = ("conflicting keymap exists for mode **%q**, lhs: **%q**"):format(tree.mode, node.mapping.prefix)
          vim.fn["health#report_warn"](msg)
          local cmd = node.mapping.cmd or " "
          vim.fn["health#report_info"](("rhs: `%s`"):format(cmd))
        end
      end
    )
  end
  for _, dup in pairs(M.duplicates) do
    local msg = ""
    if dup.buf == dup.other.buffer then
      msg = "duplicate keymap"
    else
      msg = "buffer-local keymap overriding global"
    end
    msg = (msg .. " for mode **%q**, buf: %d, lhs: **%q**"):format(dup.mode, dup.buf or 0, dup.prefix)
    if dup.buf == dup.other.buffer then
      vim.fn["health#report_error"](msg)
    else
      vim.fn["health#report_warn"](msg)
    end
    vim.fn["health#report_info"](("old rhs: `%s`"):format(dup.other.rhs or ""))
    vim.fn["health#report_info"](("new rhs: `%s`"):format(dup.cmd or ""))
  end
end

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

function M.is_hook(prefix, cmd)
  -- skip mappings with our secret nop command
  local has_secret = prefix:find(secret)
  -- skip auto which-key mappings
  local has_wk = cmd and cmd:find("which%-key") and cmd:find("auto") or false
  return has_wk or has_secret
end

---@param mode string
---@param buf number
function M.update_keymaps(mode, buf)
  ---@type Keymap[]
  local keymaps = buf and vim.api.nvim_buf_get_keymap(buf, mode) or vim.api.nvim_get_keymap(mode)
  local tree = M.get_tree(mode, buf).tree

  local function is_no_op(keymap)
    return not keymap.callback and Util.t(keymap.rhs) == ""
  end

  for _, keymap in pairs(keymaps) do
    local skip = M.is_hook(keymap.lhs, keymap.rhs)

    if is_no_op(keymap) then
      skip = true
    end

    -- check if <leader> was remapped
    if not skip and Util.t(keymap.lhs) == Util.t("<leader>") and mode == "n" then
      if is_no_op(keymap) then
        skip = true
      else
        Util.warn(
          string.format(
            "Your <leader> key for %q mode in buf %d is currently mapped to %q. WhichKey automatically creates triggers, so please remove the mapping",
            mode,
            buf or 0,
            keymap.rhs
          )
        )
      end
    end

    if not skip then
      local mapping = {
        id = Util.t(keymap.lhs),
        prefix = keymap.lhs,
        cmd = keymap.rhs,
        desc = keymap.desc,
        keys = Util.parse_keys(keymap.lhs),
      }
      -- don't include Plug keymaps
      if mapping.keys.notation[1]:lower() ~= "<plug>" then
        tree:add(mapping)
      end
    end
  end
end

return M
