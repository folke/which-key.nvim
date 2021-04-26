local Keys = require("which-key.keys")
local config = require("which-key.config")
require("which-key.colors").setup()

local M = {}

function M.setup(options) config.setup(options) end

M.register = Keys.register

return M
