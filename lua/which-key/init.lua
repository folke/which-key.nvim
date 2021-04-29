local Keys = require("which-key.keys")
local View = require("which-key.view")
local config = require("which-key.config")
local Plugin = require("which-key.plugins")
local Util = require("which-key.util")

require("which-key.colors").setup()

---@class WhichKey
local M = {}

function M.setup(options)
  config.setup(options)
  Plugin.setup()
  M.register({}, { prefix = "<leader>", mode = "n" })
  M.register({}, { prefix = "<leader>", mode = "v" })
  Keys.setup()
end

function M.show(keys, opts)
  opts = opts or {}
  if type(opts) == "string" then opts = { mode = opts } end

  keys = keys or ""

  -- mappings will pass <lt> as <, so change it back
  keys = keys:gsub("[<]", "<lt>")

  opts.mode = opts.mode or Util.get_mode()
  local buf = vim.api.nvim_get_current_buf()
  -- make sure the trees exist for update
  Keys.get_tree(opts.mode)
  Keys.get_tree(opts.mode, buf)
  -- update only trees related to buf
  Keys.update(buf)
  -- trigger which key
  View.open(keys, opts)
end

function M.show_command(keys, mode)
  keys = (keys == "\"\"" or keys == "''") and "" or keys
  mode = (mode == "\"\"" or mode == "''") and "" or mode
  mode = mode or "n"
  if not Util.check_mode(mode) then
    Util.error(
      "Invalid mode passed to :WhichKey (Dont create any keymappings to trigger WhichKey. WhichKey does this automaytically)")
  else
    M.show(keys, { mode = mode })
  end
end

M.register = Keys.register

function M.reset()
  -- local mappings = Keys.mappings
  require("plenary.reload").reload_module("which-key")
  -- require("which-key.Keys").mappings = mappings
  require("which-key").setup()
end

M.dump = Keys.dump

return M
