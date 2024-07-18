local Config = require("which-key.config")
local Util = require("which-key.util")

local M = {}

M.VERSION = 2
M.notifs = {} ---@type {msg:string, level:number, spec?:wk.Spec}[]

---@class wk.Field
---@field transform? string|(fun(value: any, parent:table): (value:any, key:string?))
---@field inherit? boolean
---@field deprecated? boolean

---@class wk.Parse
---@field version? number
---@field create? boolean
---@field notify? boolean

M.notify = true

---@type table<string, wk.Field>
M.fields = {
  -- map args
  rhs = {},
  lhs = {},
  buffer = { inherit = true },
  callback = { transform = "rhs" },
  desc = {},
  expr = { inherit = true },
  mode = { inherit = true },
  noremap = {
    transform = function(value)
      return not value, "remap"
    end,
  },
  nowait = { inherit = true },
  remap = { inherit = true },
  replace_keycodes = { inherit = true },
  script = {},
  silent = { inherit = true },
  unique = { inherit = true },
  -- wk args
  plugin = { inherit = true },
  group = {},
  hidden = { inherit = true },
  cond = { inherit = true },
  preset = { inherit = true },
  icon = { inherit = true },
  proxy = {},
  expand = {},
  -- deprecated
  name = { transform = "group", deprecated = true },
  prefix = { inherit = true, deprecated = true },
  cmd = { transform = "rhs", deprecated = true },
}

---@param msg string
---@param spec? wk.Spec
function M.error(msg, spec)
  M.log(msg, vim.log.levels.ERROR, spec)
end

---@param msg string
---@param spec? wk.Spec
function M.warn(msg, spec)
  M.log(msg, vim.log.levels.WARN, spec)
end

---@param msg string
---@param level number
---@param spec? wk.Spec
function M.log(msg, level, spec)
  if not M.notify then
    return
  end
  M.notifs[#M.notifs + 1] = { msg = msg, level = level, spec = spec }
  if Config.notify then
    Util.warn({
      "There were issues reported with your **which-key** mappings.",
      "Use `:checkhealth which-key` to find out more.",
    }, { once = true })
  end
end

---@param spec wk.Spec
---@param field string|number
---@param types string|string[]
function M.expect(spec, field, types)
  types = type(types) == "string" and { types } or types
  local ok = false
  for _, t in ipairs(types) do
    if type(spec[field]) == t then
      ok = true
      break
    end
  end
  if not ok then
    M.error("Expected `" .. field .. "` to be " .. table.concat(types, ", "), spec)
  end
  return ok
end

---@param spec wk.Spec
---@param ret? wk.Mapping[]
---@param opts? wk.Parse
function M._parse(spec, ret, opts)
  opts = opts or {}
  opts.version = opts.version or M.VERSION
  if spec.version then
    opts.version = spec.version
    spec.version = nil
  end

  if ret == nil and opts.version ~= M.VERSION then
    M.warn(
      "You're using an old version of the which-key spec.\n"
        .. "Your mappings will work, but it's recommended to update them to the new version.\n"
        .. "Please check the docs and suggested spec below for more info.\nMappings",
      vim.deepcopy(spec)
    )
  end

  ret = ret or {}

  spec = type(spec) == "string" and { desc = spec } or spec

  ---@type wk.Mapping
  local mapping = {}

  ---@type wk.Spec[]
  local children = {}

  local keys = vim.tbl_keys(spec)

  table.sort(keys, function(a, b)
    local ta, tb = type(a), type(b)
    if type(a) == type(b) then
      return a < b
    end
    return ta < tb
  end)

  -- process fields
  for _, k in ipairs(keys) do
    local v = spec[k]
    local field = M.fields[k] ---@type wk.Field?
    if field then
      if type(field.transform) == "string" then
        k = field.transform --[[@as string]]
      elseif type(field.transform) == "function" then
        local vv, kk = field.transform(v, spec)
        v, k = vv, (kk or k)
      end
      mapping[k] = v
    elseif type(k) == "string" then
      if opts.version == 1 then
        if M.expect(spec, k, { "string", "table" }) then
          if type(v) == "string" then
            table.insert(children, { prefix = (spec.prefix or "") .. k, desc = v })
          elseif type(v) == "table" then
            v.prefix = (spec.prefix or "") .. k
            table.insert(children, v)
          end
        end
      else
        M.error("Invalid field `" .. k .. "`", spec)
      end
    elseif type(k) == "number" and type(v) == "table" then
      if opts.version == 1 then
        v.prefix = spec.prefix or ""
      end
      table.insert(children, v)
      spec[k] = nil
    end
  end

  local count = #spec

  -- process mapping
  if opts.version == M.VERSION then
    if count == 1 then
      if M.expect(spec, 1, "string") then
        mapping.lhs = spec[1] --[[@as string]]
      end
    elseif count == 2 then
      if M.expect(spec, 1, "string") and M.expect(spec, 2, { "string", "function" }) then
        mapping.lhs = spec[1] --[[@as string]]
        mapping.rhs = spec[2] --[[@as string]]
      end
    elseif count > 2 then
      M.error("expected 1 or 2 elements, got " .. count, spec)
    end
  elseif opts.version == 1 then
    if mapping.expr and mapping.replace_keycodes == nil then
      mapping.replace_keycodes = false
    end
    if count == 1 then
      if M.expect(spec, 1, "string") then
        if mapping.desc then
          M.warn("overwriting desc", spec)
        end
        mapping.desc = spec[1] --[[@as string]]
      end
    elseif count == 2 then
      if M.expect(spec, 1, { "string", "function" }) and M.expect(spec, 2, "string") then
        if mapping.desc then
          M.warn("overwriting desc", spec)
        end
        mapping.rhs = spec[1] --[[@as string]]
        mapping.desc = spec[2] --[[@as string]]
      end
    elseif count > 2 then
      M.error("expected 1 or 2 elements, got " .. count, spec)
    end
  end

  -- add mapping
  M.add(mapping, ret, opts)

  -- process children
  for _, child in ipairs(children) do
    for k, v in pairs(mapping) do
      if M.fields[k] and M.fields[k].inherit and child[k] == nil then
        child[k] = v
      end
    end
    M._parse(child, ret, opts)
  end

  return ret
end

---@param mapping wk.Spec
---@param opts? wk.Parse
---@param ret wk.Mapping[]
function M.add(mapping, ret, opts)
  opts = opts or {}
  if mapping.cond == false or ((type(mapping.cond) == "function") and not mapping.cond()) then
    return
  end
  ---@cast mapping wk.Mapping|wk.Spec
  mapping.cond = nil
  if mapping.desc == "which_key_ignore" then
    mapping.hidden = true
    mapping.desc = nil
  end
  if type(mapping.group) == "string" or type(mapping.group) == "function" then
    mapping.desc = mapping.group --[[@as string]]
    mapping.group = true
  end
  if mapping.plugin then
    mapping.group = true
  end
  if mapping.group and mapping.desc then
    mapping.desc = mapping.desc
    if type(mapping.desc) == "string" then
      mapping.desc = mapping.desc:gsub("^%+", "")
    end
  end
  if mapping.buffer == 0 or mapping.buffer == true then
    mapping.buffer = vim.api.nvim_get_current_buf()
  end
  if mapping.rhs then
    mapping.silent = mapping.silent ~= false
  end
  mapping.lhs = mapping.lhs or mapping.prefix
  if not mapping.lhs then
    return
  end
  mapping.prefix = nil

  local has_desc = mapping.desc ~= nil
  Util.getters(mapping, { "desc", "icon" })

  if has_desc or mapping.group or mapping.hidden or mapping.rhs or (opts.version == M.VERSION and mapping.lhs) then
    local modes = mapping.mode or { "n" } --[[@as string|string[] ]]
    modes = type(modes) == "string" and vim.split(modes, "") or modes --[[@as string[] ]]
    for _, mode in ipairs(modes) do
      if mode ~= "v" and mode ~= Util.mapmode(mode) then
        M.warn("Invalid mode `" .. mode .. "`", mapping)
      end
      local m = vim.deepcopy(mapping)
      m.mode = mode
      table.insert(ret, m)
    end
  end
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

---@param spec wk.Spec
---@param opts? wk.Parse
function M.parse(spec, opts)
  opts = opts or {}
  M.notify = opts.notify ~= false
  local ret = M._parse(spec, nil, opts)
  M.notify = true
  for _, m in ipairs(ret) do
    if m.rhs and opts.create then
      M.create(m)
    end
  end
  return ret
end

return M
