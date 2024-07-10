local Config = require("which-key.config")

local M = {}

---@type table<string, wk.Plugin>
M.plugins = {}

function M.setup()
  for name, opts in pairs(Config.options.plugins) do
    -- only setup plugin if we didnt load it before
    if not M.plugins[name] then
      if type(opts) == "boolean" then
        opts = { enabled = opts }
      end
      opts.enabled = opts.enabled ~= false
      if opts.enabled then
        M.plugins[name] = require("which-key.plugins." .. name)
        M._setup(M.plugins[name], opts)
      end
    end
  end
end

---@param plugin wk.Plugin
function M._setup(plugin, opts)
  if plugin.actions then
    for _, trigger in pairs(plugin.actions) do
      local prefix = trigger.trigger
      local mode = trigger.mode or "n"
      local label = trigger.label or plugin.name
      Config.register({ [prefix] = { label, plugin = plugin.name } }, { mode = mode })
    end
  end

  if plugin.setup then
    plugin.setup(opts)
  end
end

---@param name string
function M.expand(name)
  local plugin = M.plugins[name]
  assert(plugin, "plugin not found")
  return plugin.expand()
end

---@class wk.Node.plugin: wk.Node
local PluginNode = {}

function PluginNode:__index(k)
  if k == "children" then
    assert(self.plugin, "node must be a plugin node")

    local plugin = M.plugins[self.plugin or ""]
    assert(plugin, "plugin not found")
    local ret = {} ---@type table<string, wk.Node>
    for i, item in ipairs(plugin.expand()) do
      ---@type string[]
      local child_path = vim.list_extend({}, self.path)
      child_path[#child_path + 1] = item.key

      ---@type wk.Node
      local child = {
        key = item.key,
        path = child_path,
        parent = self,
        desc = item.desc,
        order = i,
        value = item.value,
        action = item.action,
      }
      ret[item.key] = child
    end
    return ret
  end
end

M.PluginNode = PluginNode

return M
