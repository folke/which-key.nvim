local Keys = require("which-key.keys")
local Util = require("which-key.util")

local M = {}

M.plugins = {}

---@param plugin Plugin
function M.setup(plugin)
  M.plugins[plugin.name] = plugin

  for _, trigger in pairs(plugin.triggers) do
    local prefix = trigger
    local mode = "n"
    if type(trigger) == "table" then
      prefix = trigger[1]
      mode = trigger[2]
    end

    Keys.register({ [prefix] = { plugin.name, plugin = plugin.name } }, { mode = mode })
  end
end

---@param results MappingGroup
function M.invoke(results)
  print("running plugin")
  local plugin = M.plugins[results.mapping.plugin]
  local prefix = results.mapping.prefix
  local items = plugin.handler(prefix, results.mode, results.buf)

  for _, item in pairs(items) do
    ---@type VisualMapping
    local mapping
    mapping = {
      key = item.key,
      label = item.label,
      keys = Util.parse_keys(prefix .. item.key),
      prefix = prefix,
      value = item.value,
      highlights = item.highlights,
    }
    table.insert(results.mappings, mapping)
  end
end

return M
