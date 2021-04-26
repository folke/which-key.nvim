local M = {}

M.namespace = vim.api.nvim_create_namespace("WhichKey")

---@class Options
local defaults = {}

---@type Options
M.options = {}

---@return Options
function M.setup(options) M.options = vim.tbl_deep_extend("force", {}, defaults, options or {}) end

M.setup()

return M
