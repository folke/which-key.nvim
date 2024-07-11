local Docs = require("lazy.docs")

local M = {}

function M.update()
  local config = Docs.extract("lua/which-key/config.lua", "\n(--@class wk%.Opts.-\n})")
  config = config:gsub("%s*debug = false.\n", "\n")
  Docs.save({
    config = config,
    colors = Docs.colors({
      modname = "which-key.colors",
      path = "lua/which-key/colors.lua",
      name = "WhichKey",
    }),
  })
end

M.update()
print("Updated docs")

return M
