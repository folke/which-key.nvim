local Config = require("which-key.config")
local Util = require("which-key.util")

local M = {}

---@type table<string, wk.Plugin>
M.plugins = {}

function M.setup()
  for name, opts in pairs(Config.plugins) do
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
  if plugin.mappings then
    Config.add(plugin.mappings)
  end

  if plugin.setup then
    plugin.setup(opts)
  end
end

---@param name string
function M.cols(name)
  local plugin = M.plugins[name]
  assert(plugin, "plugin not found")
  local ret = {} ---@type wk.Col[]
  vim.list_extend(ret, plugin.cols or {})
  ret[#ret + 1] = { key = "value", hl = "WhichKeyValue", width = 0.5 }
  return ret
end

---@class wk.Node.plugin.item: wk.Node,wk.Plugin.item

return M
