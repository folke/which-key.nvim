local Util = require("which-key.util")

local M = {}

local function lookup(...)
  local ret = {}
  for _, t in ipairs({ ... }) do
    for _, v in ipairs(t) do
      ret[v] = v
    end
  end
  return ret
end

local mapargs = {
  "noremap",
  "desc",
  "expr",
  "silent",
  "nowait",
  "script",
  "unique",
  "replace_keycodes", -- TODO: add config setting for default value
}
local wkargs = {
  "prefix",
  "mode",
  "plugin",
  "buffer",
  "remap",
  "cmd",
  "name",
  "group",
  "preset",
  "cond",
}
local transargs = lookup({
  "noremap",
  "remap",
  "expr",
  "silent",
  "nowait",
  "script",
  "unique",
  "prefix",
  "mode",
  "buffer",
  "preset",
  "replace_keycodes",
})
local args = lookup(mapargs, wkargs)

function M.child_opts(opts)
  local ret = {}
  for k, v in pairs(opts) do
    if transargs[k] then
      ret[k] = v
    end
  end
  return ret
end

function M._process(value, opts)
  local list = {}
  local children = {}
  for k, v in pairs(value) do
    if type(k) == "number" then
      if type(v) == "table" then
        -- nested child, without key
        table.insert(children, v)
      else
        -- list value
        table.insert(list, v)
      end
    elseif args[k] then
      -- option
      opts[k] = v
    else
      -- nested child, with key
      children[k] = v
    end
  end
  return list, children
end

function M._parse(value, mappings, opts)
  if type(value) ~= "table" then
    value = { value }
  end

  local list, children = M._process(value, opts)

  if opts.plugin then
    opts.group = true
  end
  if opts.name then
    -- remove + from group names
    opts.name = opts.name and opts.name:gsub("^%+", "")
    opts.group = true
  end

  -- fix remap
  if opts.remap ~= nil then
    opts.noremap = not opts.remap
    opts.remap = nil
  end

  -- fix buffer
  if opts.buffer == 0 then
    opts.buffer = vim.api.nvim_get_current_buf()
  end

  if opts.cond ~= nil then
    if type(opts.cond) == "function" then
      if not opts.cond() then
        return
      end
    elseif not opts.cond then
      return
    end
  end

  -- process any array child mappings
  for k, v in pairs(children) do
    local o = M.child_opts(opts)
    if type(k) == "string" then
      o.prefix = (o.prefix or "") .. k
    end
    M._try_parse(v, mappings, o)
  end

  -- { desc }
  if #list == 1 then
    if type(list[1]) ~= "string" then
      error("Invalid mapping for " .. vim.inspect({ value = value, opts = opts }))
    end
    opts.desc = opts.desc or list[1]
  -- { cmd, desc }
  elseif #list == 2 then
    -- desc
    assert(type(list[2]) == "string")
    opts.desc = list[2]

    -- cmd
    if type(list[1]) == "string" then
      opts.cmd = list[1]
    elseif type(list[1]) == "function" then
      opts.cmd = ""
      opts.callback = list[1]
    else
      error("Incorrect mapping " .. vim.inspect(list))
    end
  elseif #list > 2 then
    error("Incorrect mapping " .. vim.inspect(list))
  end

  if opts.desc or opts.group then
    if type(opts.mode) == "table" then
      for _, mode in pairs(opts.mode) do
        local mode_opts = vim.deepcopy(opts)
        mode_opts.mode = mode
        table.insert(mappings, mode_opts)
      end
    else
      table.insert(mappings, opts)
    end
  end
end

---@return wk.Keymap
function M.to_mapping(mapping)
  ---@cast mapping Mapping | wk.Keymap
  mapping.silent = mapping.silent ~= false
  mapping.rhs = mapping.cmd
  if mapping.rhs and mapping.rhs:lower():find("^<plug>") then
    mapping.remap = true
  end

  if mapping.replace_keycodes == nil and mapping.expr then
    mapping.replace_keycodes = true
  end

  mapping.lhs = mapping.prefix
  mapping.prefix = nil

  mapping.mode = mapping.mode or "n"
  mapping.desc = mapping.desc or mapping.name
  mapping.name = nil

  return mapping
end

function M._try_parse(value, mappings, opts)
  local ok, err = pcall(M._parse, value, mappings, opts)
  if not ok then
    Util.error(err)
  end
end

---@param map wk.Keymap
function M.opts(map)
  local ret = {}
  for _, k in ipairs(mapargs) do
    if map[k] ~= nil then
      ret[k] = map[k]
    end
  end
  return ret
end

---@return wk.Keymap[]
function M.parse(mappings, opts)
  opts = opts or {}
  local ret = {}
  M._try_parse(mappings, ret, opts)
  return vim.tbl_map(function(m)
    return M.to_mapping(m)
  end, ret)
end

return M
