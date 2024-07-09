local Keys = require("which-key.keys")
local Util = require("which-key.util")

---@class WhichKey
local M = {}

function M.show(keys, opts) end

---@type wk.Keymap[]
M.mappings = {}

-- Defer registering keymaps until VimEnter
function M.register(mappings, opts)
  local ret = require("which-key.mappings").parse(mappings, opts)
  vim.list_extend(M.mappings, ret)
end

function M.setup()
  require("which-key.colors").setup()
  require("which-key.state").setup()
end

return M
