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

function M.show(keys, opts)
  opts = opts or {}
  if type(opts) == "string" then opts = { mode = opts } end

  keys = keys or ""
  opts.mode = opts.mode or vim.api.nvim_get_mode().mode
  local buf = vim.api.nvim_get_current_buf()
  -- make sure the trees exist for update
  Keys.get_tree(opts.mode)
  Keys.get_tree(opts.mode, buf)
  -- update only trees related to buf
  Keys.update(buf)
  -- trigger which key
  View.on_keys(keys, opts)
end

M.register = Keys.register

return M
