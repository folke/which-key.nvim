local Keys = require("which-key.keys")
local config = require("which-key.config")
local Layout = require("which-key.layout")
local Util = require("which-key.util")

local highlight = vim.api.nvim_buf_add_highlight

---@class View
local M = {}

M.keys = ""
M.mode = "n"
M.back = false
M.buf = nil
M.win = nil

function M.is_valid()
  return M.buf and vim.api.nvim_buf_is_valid(M.buf) and vim.api.nvim_buf_is_loaded(M.buf) and
           vim.api.nvim_win_is_valid(M.win)
end

function M.show()
  if M.is_valid() then return end
  local opts = {
    relative = "editor",
    width = vim.o.columns - config.options.window.margin[2] - config.options.window.margin[4],
    height = config.options.layout.height.min,
    focusable = false,
    anchor = "SW",
    border = config.options.window.border,
    row = vim.o.lines - 1 - config.options.window.margin[3],
    col = config.options.window.margin[2],
    style = "minimal",
  }
  if config.options.window.position == "top" then
    opts.anchor = "NW"
    opts.row = config.options.window.margin[1]
  end
  M.buf = vim.api.nvim_create_buf(false, true)
  M.win = vim.api.nvim_open_win(M.buf, false, opts)
  vim.api.nvim_win_set_option(M.win, "winhighlight", "NormalFloat:WhichKeyFloating")
  vim.cmd [[autocmd! WinClosed <buffer> lua require("which-key.view").on_close()]]
end

function M.get_input(wait)
  while true do
    local n = wait and vim.fn.getchar() or vim.fn.getchar(0)
    if n == 0 then return end
    local c = (type(n) == "number" and vim.fn.nr2char(n) or n)

    -- Fix < characters
    if c == "<" then c = "<lt>" end

    if c == Util.t("<esc>") then
      M.on_close()
      return
    elseif c == Util.t("<c-d>") then
      M.scroll(false)
    elseif c == Util.t("<c-u>") then
      M.scroll(true)
    elseif c == Util.t("<bs>") then
      M.back()
    else
      M.keys = M.keys .. c
    end

    if wait then
      vim.defer_fn(function() M.on_keys(M.keys) end, 0)
      return
    end
  end
end

function M.scroll(up)
  local height = vim.api.nvim_win_get_height(M.win)
  local cursor = vim.api.nvim_win_get_cursor(M.win)
  if up then
    cursor[1] = math.max(cursor[1] - height, 1)
  else
    cursor[1] = math.min(cursor[1] + height, vim.api.nvim_buf_line_count(M.buf))
  end
  vim.api.nvim_win_set_cursor(M.win, cursor)
end

function M.on_close()
  print(M.keys)
  M.hide()
end

function M.hide()
  M.hide_cursor()
  if M.buf and vim.api.nvim_buf_is_valid(M.buf) then
    vim.api.nvim_buf_delete(M.buf, { force = true })
    M.buf = nil
  end
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, { force = true })
    M.win = nil
  end
end

function M.show_cursor()
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_add_highlight(buf, config.namespace, "Cursor", cursor[1] - 1, cursor[2],
                                 cursor[2] + 1)
end

function M.hide_cursor()
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(buf, config.namespace, 0, -1)
end

function M.back()
  local buf = vim.api.nvim_get_current_buf()
  local node = Keys.get_tree(M.mode, buf).tree:get(M.keys, 1) or
                 Keys.get_tree(M.mode).tree:get(M.keys, 1)
  if node then M.keys = node.prefix end
end

function M.on_keys(keys, mode)
  M.keys = keys or ""
  M.mode = mode or vim.api.nvim_get_mode().mode
  M.show_cursor()
  -- eat queued characters
  M.get_input(false)

  local mappings = Keys.get_mappings(M.mode, M.keys, vim.api.nvim_get_current_buf())

  --- Check for an exact match. Feedkeys with remap
  if mappings.mapping and not mappings.mapping.group then
    M.hide()
    if mappings.mapping.cmd then
      vim.api.nvim_feedkeys(M.keys, "m", true)
    else
      vim.api.nvim_feedkeys(M.keys, "n", true)
    end
    return
  end

  -- Check for no mappings found. Feedkeys without remap
  if #mappings.mappings == 0 then
    M.hide()
    vim.api.nvim_feedkeys(M.keys, "n", true)
    return
  end

  local layout = Layout:new(mappings)

  if not M.is_valid() then M.show() end

  M.render(layout:layout(M.win))

  -- defer further eating on the main loop
  vim.defer_fn(function() M.get_input(true) end, 0)
end

---@param text Text
function M.render(text)
  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, text.lines)
  local height = #text.lines
  if height > config.options.layout.height.max then height = config.options.layout.height.max end
  vim.api.nvim_win_set_height(M.win, height)
  if vim.api.nvim_buf_is_valid(M.buf) then
    vim.api.nvim_buf_clear_namespace(M.buf, config.namespace, 0, -1)
  end
  for _, data in ipairs(text.hl) do
    highlight(M.buf, config.namespace, data.group, data.line, data.from, data.to)
  end
end

return M
