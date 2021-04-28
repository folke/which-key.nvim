local Keys = require("which-key.keys")
local Util = require("which-key.util")
local Config = require("which-key.config")

local M = {}

M.plugins = {}

function M.setup()
  for name, plugin in pairs(M.plugins) do
    local opts = Config.options.plugins[name]
    if opts == nil then opts = {} end
    if type(opts) == "boolean" then opts = { enabled = opts } end
    opts.enabled = opts.enabled ~= false
    if opts.enabled then
      if type(plugin) == "string" then
        plugin = require(plugin)
        M.plugins[name] = plugin
      end
      if not plugin.loaded then M._setup(plugin, opts) end
    end
  end
end

function M.register(plugin, name) M.plugins[name or plugin.name] = plugin end

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

  if plugin.setup then plugin.setup(require("which-key"), opts) end
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

-- Register builtin plugins
local builtin = { "marks", "registers", "text-objects", "operators", "motions" }
for _, name in pairs(builtin) do M.register("which-key.plugins." .. name, name) end

return M
