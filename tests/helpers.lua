local M = {}

---@param lines? string[]
function M.reset(lines)
  vim.o.showmode = false
  vim.api.nvim_feedkeys(vim.keycode("<Ignore><C-\\><C-n><esc>"), "nx", false)
  vim.cmd("enew")
  vim.cmd("normal! <c-w>o")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines or {})
end

return M
