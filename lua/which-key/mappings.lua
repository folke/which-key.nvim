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
  "callback",
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
  if opts.remap then
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
    opts.desc = list[1]
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

---@return Mapping
function M.to_mapping(mapping)
  mapping.silent = mapping.silent ~= false
  mapping.noremap = mapping.noremap ~= false
  if mapping.cmd and mapping.cmd:lower():find("^<plug>") then
    mapping.noremap = false
  end

  mapping.buf = mapping.buffer
  mapping.buffer = nil

  mapping.mode = mapping.mode or "n"
  mapping.label = mapping.desc or mapping.name
  mapping.keys = Util.parse_keys(mapping.prefix or "")

  local opts = {}
  for _, o in ipairs(mapargs) do
    opts[o] = mapping[o]
    mapping[o] = nil
  end

  if vim.fn.has("nvim-0.7.0") == 0 then
    opts.replace_keycodes = nil

    -- Neovim < 0.7.0 doesn't support descriptions
    opts.desc = nil

    -- use lua functions proxy for Neovim < 0.7.0
    if opts.callback then
      local functions = require("which-key.keys").functions
      table.insert(functions, opts.callback)
      if opts.expr then
        opts.cmd = string.format([[luaeval('require("which-key").execute(%d)')]], #functions)
      else
        opts.cmd = string.format([[<cmd>lua require("which-key").execute(%d)<cr>]], #functions)
      end
      opts.callback = nil
    end
  end

  mapping.opts = opts
  return mapping
end

function M._try_parse(value, mappings, opts)
  local ok, err = pcall(M._parse, value, mappings, opts)
  if not ok then
    Util.error(err)
  end
end

---@return Mapping[]
function M.parse(mappings, opts)
  opts = opts or {}
  local ret = {}
  M._try_parse(mappings, ret, opts)
  return vim.tbl_map(function(m)
    return M.to_mapping(m)
  end, ret)
end

return M
