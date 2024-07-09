local Config = require("which-key.config")
local State = require("which-key.state")
local Util = require("which-key.util")

local M = {}
M.buf = nil ---@type number
M.win = nil ---@type number
M.timer = vim.uv.new_timer()

local dw = vim.fn.strdisplaywidth

function M.valid()
  return M.buf and vim.api.nvim_buf_is_valid(M.buf) and M.win and vim.api.nvim_win_is_valid(M.win)
end

function M.update()
  if M.valid() then
    M.show()
  else
    M.timer:start(Config.ui.delay, 0, vim.schedule_wrap(M.show))
  end
end

function M.hide()
  ---@type number?, number?
  local buf, win = M.buf, M.win
  M.buf, M.win = nil, nil

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

function M.mount()
  if M.valid() then
    return
  end
  M.buf = vim.api.nvim_create_buf(false, true)
  vim.bo[M.buf].buftype = "nofile"
  vim.bo[M.buf].bufhidden = "wipe"
  vim.bo[M.buf].filetype = "wk"
  M.win = vim.api.nvim_open_win(M.buf, false, {
    relative = "editor",
    focusable = false,
    width = 40,
    height = 30,
    row = vim.o.lines - 20,
    col = vim.o.columns - 40,
    style = "minimal",
    border = "single",
  })
end

function M.show()
  local state = State.state
  if not state or not state.node.children then
    M.hide()
    return
  end
  M.mount()
  local text = require("which-key.text").new({
    padding = 1,
  })

  ---@type wk.Node[]
  local children = vim.tbl_values(state.node.children or {})

  table.sort(children, function(a, b)
    local ag = a.keymap and 0 or 1
    local bg = b.keymap and 0 or 1
    if ag ~= bg then
      return ag < bg
    end
    local al = a.key:lower()
    local bl = b.key:lower()
    if al ~= bl then
      return al < bl
    end
    return a.key > b.key
  end)

  local width = 0
  for _, node in ipairs(children) do
    width = math.max(width, dw(node.key))
  end

  for _, node in ipairs(children) do
    local desc = node.desc
    if not desc and node.keymap then
      desc = node.keymap.rhs and tostring(node.keymap.rhs) or nil
    end
    desc = desc or ""
    desc = desc:gsub("^%++", "")
    text:append(string.rep(" ", width - dw(node.key)) .. node.key, "WhichKey")
    text:append(" ➜ ", "WhichKeySeparator")
    if desc then
      if not node.keymap then
        desc = "+" .. desc
      end
      text:append(desc, node.keymap and "WhichKeyDesc" or "WhichKeyGroup")
    end
    text:nl()
  end
  local title = {
    { " " .. table.concat(state.node.path) .. " ", "FloatTitle" },
  }
  if state.debug then
    table.insert(title, { " " .. state.debug .. " ", "FloatTitle" })
  end
  if state.node.desc then
    local desc = state.node.desc or ""
    desc = desc:gsub("^%++", "")
    desc = "+" .. desc
    table.insert(title, { " " .. desc .. " ", "FloatTitle" })
  end

  local height = text:height() - 1
  vim.api.nvim_win_set_config(M.win, {
    title = title,
    relative = "editor",
    height = height,
    row = vim.o.lines - height - 3,
    col = vim.o.columns - 40,
  })
  text:render(M.buf)
  vim.cmd.redraw()
end

return M
