local Keys = require("which-key.keys")
local Util = require("which-key.util")
local Config = require("which-key.config")

local M = {}

M.plugins = {}

function M.setup()
  for name, opts in pairs(Config.options.plugins) do
    -- only setup plugin if we didnt load it before
    if not M.plugins[name] then
      if type(opts) == "boolean" then opts = { enabled = opts } end
      opts.enabled = opts.enabled ~= false
      if opts.enabled then
        M.plugins[name] = require("which-key.plugins." .. name)
        M._setup(M.plugins[name], opts)
      end
    end
  end
end

---@param plugin Plugin
function M._setup(plugin, opts)
  if plugin.actions then
    for _, trigger in pairs(plugin.actions) do
      local prefix = trigger.trigger
      local mode = trigger.mode or "n"
      local label = trigger.label or plugin.name

      Keys.register({ [prefix] = { label, plugin = plugin.name } }, { mode = mode })
    end
  end

  if plugin.setup then plugin.setup(require("which-key"), opts, Config.options) end
end

---@param results MappingGroup
function M.invoke(results)
  local plugin = M.plugins[results.mapping.plugin]
  local prefix = results.mapping.prefix
  local items = plugin.run(prefix, results.mode, results.buf)

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
