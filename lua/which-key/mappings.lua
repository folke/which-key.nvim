local Util = require("which-key.util")

local M = {}

---@class wk.Field
---@field transform? string|(fun(value: any, parent:table): (value:any, key:string?))
---@field inherit? boolean

---@type table<string, wk.Field>
M.fields = {
  buffer = { inherit = true },
  callback = { transform = "rhs" },
  prefix = { transform = "lhs" },
  desc = {},
  expr = {},
  mode = { inherit = true },
  noremap = {
    transform = function(value)
      return not value, "remap"
    end,
    inherit = true,
  },
  nowait = { inherit = true },
  remap = { inherit = true },
  replace_keycodes = { inherit = true },
  script = {},
  silent = { inherit = true },
  unique = {},
  plugin = { inherit = true },
  hidden = { inherit = true },
  cond = { inherit = true },
  preset = { inherit = true },
  name = {},
  cmd = { transform = "rhs" },
  group = {},
  icon = { inherit = true },
  rhs = {},
  lhs = {},
}

---@param value wk.Spec
---@param parent? wk.Mapping
---@param ret? wk.Mapping[]
function M._parse(value, parent, ret)
  if type(value) == "string" then
    value = { desc = value }
  end
  ret = ret or {}
  parent = parent or {}
  local mapping = vim.deepcopy(parent)
  ---@type {[1]:string, [2]:wk.Spec}[]
  local children = {}

  mapping.lhs = (parent.lhs or "")

  local keys = vim.tbl_keys(value)
  table.sort(keys, function(a, b)
    return tostring(a) < tostring(b)
  end)

  -- process fields
  for _, k in ipairs(keys) do
    local v = value[k]
    local field = M.fields[k]
    if field then
      if type(field.transform) == "string" then
        k = field.transform
      elseif type(field.transform) == "function" then
        local kk = k
        v, k = field.transform(v, parent)
        k = k or kk
      end
      mapping[k] = v
    elseif type(k) == "string" then
      table.insert(children, { k, v })
    elseif type(k) == "number" and type(v) == "table" then
      value[k] = nil
      table.insert(children, { "", v })
    end
  end

  local count = #value

  if count == 1 then
    assert(type(value[1]) == "string", "Invalid mapping " .. vim.inspect(value))
    if mapping.desc then
      mapping.rhs = value[1] --[[@as string]]
    else
      mapping.desc = value[1] --[[@as string]]
    end
  elseif count == 2 then
    if mapping.desc then
      Util.error("Invalid mapping " .. vim.inspect(value))
    else
      mapping.rhs = value[1] --[[@as string]]
      mapping.desc = value[2] --[[@as string]]
    end
  elseif count > 2 then
    Util.error("Invalid mapping " .. vim.inspect(value))
  end

  M.add(mapping, ret)

  parent = {}
  for k, v in pairs(mapping) do
    if M.fields[k] and M.fields[k].inherit then
      parent[k] = v
    end
  end
  for _, child in ipairs(children) do
    parent.lhs = mapping.lhs .. child[1]
    M._parse(child[2], parent, ret)
  end
  return ret
end

---@param mapping wk.Mapping
function M.create(mapping)
  assert(mapping.lhs, "Missing lhs")
  assert(mapping.mode, "Missing mode")
  assert(mapping.rhs, "Missing rhs")
  local valid =
    { "remap", "noremap", "buffer", "silent", "nowait", "expr", "unique", "script", "desc", "replace_keycodes" }
  local opts = {} ---@type vim.keymap.set.Opts
  for _, k in ipairs(valid) do
    if mapping[k] ~= nil then
      opts[k] = mapping[k]
    end
  end
  vim.keymap.set(mapping.mode, mapping.lhs, mapping.rhs, opts)
end

---@param mapping wk.Spec
---@param ret wk.Mapping[]
function M.add(mapping, ret)
  if mapping.cond == false or ((type(mapping.cond) == "function") and not mapping.cond()) then
    return
  end
  mapping.cond = nil
  if mapping.desc == "which_key_ignore" then
    mapping.hidden = true
    mapping.desc = nil
  end
  if mapping.plugin then
    mapping.group = true
  end
  if mapping.name then
    mapping.desc = mapping.name:gsub("^%+", "")
    mapping.group = true
    mapping.name = nil
  end
  if mapping.buffer == 0 then
    mapping.buffer = vim.api.nvim_get_current_buf()
  end
  if mapping.rhs then
    mapping.silent = mapping.silent ~= false
  end

  if mapping.desc or mapping.group or mapping.hidden then
    local modes = mapping.mode or { "n" } --[[@as string|string[] ]]
    modes = type(modes) == "string" and vim.split(modes, "") or modes
    assert(type(modes) == "table", "Invalid mode " .. vim.inspect(modes))
    for _, mode in ipairs(modes) do
      local m = vim.deepcopy(mapping)
      m.mode = mode
      table.insert(ret, m)
    end
  end
end

---@param value wk.Spec
---@param parent? wk.Mapping
---@param opts? {create?:boolean}
---@return wk.Mapping[]
function M.parse(value, parent, opts)
  opts = opts or {}
  local ret = M._parse(value, parent)
  return vim.tbl_filter(function(v)
    if v.rhs and opts.create then
      M.create(v)
      return false
    end
    return true
  end, ret)
end

return M
