local Keys = require("which-key.keys")
local View = require("which-key.view")
local config = require("which-key.config")
local Plugin = require("which-key.plugins")

require("which-key.colors").setup()

---@class WhichKey
local M = {}

function M.setup(options)
  config.setup(options)
  Plugin.setup()
end

function M.register_plugin(plugin) Plugin.register(plugin) end

function M.show(keys, mode)
  keys = keys or ""
  mode = mode or vim.api.nvim_get_mode().mode
  local buf = vim.api.nvim_get_current_buf()
  -- make sure the trees exist for update
  Keys.get_tree(mode)
  Keys.get_tree(mode, buf)
  -- update only trees related to buf
  Keys.update(buf)
  -- trigger which key
  View.on_keys(keys, mode)
end

M.register = Keys.register

return M
