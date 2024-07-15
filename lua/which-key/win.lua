local Util = require("which-key.util")

---@class wk.Win
---@field win? number
---@field buf? number
---@field opts wk.Win.opts
local M = {}
M.__index = M

---@class wk.Win.opts
local override = {
  relative = "editor",
  style = "minimal",
  focusable = false,
  noautocmd = true,
  wo = {
    scrolloff = 0,
    foldenable = false,
    winhighlight = "Normal:WhichKeyNormal,FloatBorder:WhichKeyBorder,FloatTitle:WhichKeyTitle",
    winbar = "",
    statusline = "",
    wrap = false,
  },
  bo = {
    buftype = "nofile",
    bufhidden = "wipe",
    filetype = "wk",
  },
}

---@type wk.Win.opts
local defaults = { col = 0, row = math.huge, zindex = 1000 }

---@param opts? wk.Win.opts
function M.defaults(opts)
  return vim.tbl_deep_extend("force", {}, defaults, opts or {}, override)
end

---@param opts? wk.Win.opts
function M.new(opts)
  local self = setmetatable({}, M)
  self.opts = M.defaults(opts)
  return self
end

function M:valid()
  return self.buf and vim.api.nvim_buf_is_valid(self.buf) and self.win and vim.api.nvim_win_is_valid(self.win) or false
end

function M:hide()
  if not (self.buf or self.win) then
    return
  end

  ---@type number?, number?
  local buf, win = self.buf, self.win
  self.buf, self.win = nil, nil

  local function try_close()
    pcall(vim.api.nvim_win_close, win, true)
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
    win = win and vim.api.nvim_win_is_valid(win) and win or nil
    buf = buf and vim.api.nvim_buf_is_valid(buf) and buf or nil
    if win or buf then
      vim.schedule(try_close)
    end
  end

  try_close()
end

---@param opts? wk.Win.opts
function M:show(opts)
  if opts then
    self.opts = vim.tbl_deep_extend("force", self.opts, opts)
  end
  local win_opts = vim.deepcopy(self.opts)
  win_opts.wo = nil
  win_opts.bo = nil
  win_opts.padding = nil
  win_opts.no_overlap = nil

  if vim.fn.has("nvim-0.10") == 0 then
    win_opts.footer = nil
  end

  if self:valid() then
    win_opts.noautocmd = nil
    return vim.api.nvim_win_set_config(self.win, win_opts)
  end

  local ei = vim.go.eventignore
  vim.go.eventignore = "all"

  self.buf = vim.api.nvim_create_buf(false, true)
  Util.bo(self.buf, self.opts.bo or {})
  self.win = vim.api.nvim_open_win(self.buf, false, win_opts)
  Util.wo(self.win, self.opts.wo or {})

  vim.go.eventignore = ei
end

---@param up boolean
function M:scroll(up)
  if not self:valid() then
    return
  end
  local height = vim.api.nvim_win_get_height(self.win)
  local delta = math.ceil((up and -1 or 1) * height / 2)
  local view = vim.api.nvim_win_call(self.win, vim.fn.winsaveview)
  local top = view.topline ---@type number
  top = top + delta
  top = math.max(top, 1)
  top = math.min(top, vim.api.nvim_buf_line_count(self.buf) - height + 1)
  vim.api.nvim_win_call(self.win, function()
    vim.fn.winrestview({ topline = top, lnum = top })
  end)
end

return M
