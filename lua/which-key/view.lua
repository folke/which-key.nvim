local Keys = require("which-key.keys")
local config = require("which-key.config")
local Text = require("which-key.text")

local highlight = vim.api.nvim_buf_add_highlight

---@class View
local M = {}

M.keys = ""
M.buf = nil
M.win = nil

function M.is_valid()
  return M.buf and vim.api.nvim_buf_is_valid(M.buf) and vim.api.nvim_buf_is_loaded(M.buf) and
           vim.api.nvim_win_is_valid(M.win)

end

function M.show()
  if M.is_valid() then return end
  M.buf = vim.api.nvim_create_buf(false, true)
  M.win = vim.api.nvim_open_win(M.buf, false, {
    relative = "editor",
    width = vim.o.columns,
    height = 10,
    focusable = false,
    anchor = "SW",
    row = vim.o.lines - 2,
    col = 0,
    style = "minimal",
  })
  vim.api.nvim_win_set_option(M.win, "winhighlight", "NormalFloat:WhichKeyFloating")
  vim.cmd [[autocmd! WinClosed <buffer> lua require("which-key.view").on_close()]]
end

function M.eat(wait)
  while true do
    local n = wait and vim.fn.getchar() or vim.fn.getchar(0)
    if n == 0 then return end
    if n == 27 then -- <esc> key
      M.on_close()
      return
    end
    M.keys = M.keys .. (type(n) == "number" and vim.fn.nr2char(n) or n)
    if wait then
      vim.defer_fn(function() M.on_keys(M.keys) end, 0)
      return
    end
  end
end

function M.on_close()
  print(M.keys)
  M.hide()
end

function M.hide()
  if M.buf and vim.api.nvim_buf_is_valid(M.buf) then
    vim.api.nvim_buf_delete(M.buf, { force = true })
    M.buf = nil
  end
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, { force = true })
    M.win = nil
  end
end

---@param text Text
function M.render_mapping(text, mapping)
  text:render(mapping.lhs, "")
  text:render("->", "Seperator")
  if mapping.group == true then
    text:render(mapping.label or mapping.rhs or "", "Group")
  else
    text:render(mapping.label or mapping.rhs or "", "Desc")
  end
  text:nl()
end

function M.on_keys(keys)
  M.keys = keys or ""
  -- eat queued characters
  M.eat(false)

  local mappings = Keys.get_keymap(vim.api.nvim_get_mode().mode, M.keys,
                                   vim.api.nvim_get_current_buf())

  local text = Text:new()
  for _, mapping in pairs(mappings) do
    -- Exact match found, trigger keymapping
    if mapping.id == Keys.t(M.keys) then
      if mapping.group ~= true then
        M.hide()
        vim.api.nvim_feedkeys(M.keys, "m", true)
        return
      else -- skip this exact prefix group
      end
    end
    M.render_mapping(text, mapping)
  end

  if #text.lines == 0 then
    -- no mappings found. Feed back the keys
    M.hide()
    vim.api.nvim_feedkeys(M.keys, "n", true)
    return
  end

  if not M.is_valid() then M.show() end

  M.render(text)

  -- defer further eating on the main loop
  vim.defer_fn(function() M.eat(true) end, 0)
end

---@param text Text
function M.render(text)
  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, text.lines)
  if vim.api.nvim_buf_is_valid(M.buf) then
    vim.api.nvim_buf_clear_namespace(M.buf, config.namespace, 0, -1)
  end
  for _, data in ipairs(text.hl) do
    highlight(M.buf, config.namespace, data.group, data.line, data.from, data.to)
  end
end

return M
