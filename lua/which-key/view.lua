local Config = require("which-key.config")
local Layout = require("which-key.layout")
local State = require("which-key.state")
local Tree = require("which-key.tree")
local Util = require("which-key.util")

local M = {}
M.buf = nil ---@type number
M.win = nil ---@type number
M.timer = vim.uv.new_timer()

---@alias wk.Item { node: wk.Node, key: string, desc: string, value?: string, group?: boolean }

---@alias wk.Sorter fun(node:wk.Item): (string|number)

---@type table<string, wk.Sorter>
M.fields = {
  order = function(item)
    return item.node.order and item.node.order or 1000
  end,
  desc = function(item)
    return item.desc or "~"
  end,
  group = function(item)
    return item.group and 1 or 0
  end,
  alphanum = function(item)
    return item.key:find("^%w+$") and 0 or 1
  end,
  mod = function(item)
    return item.key:find("^<.*>$") and 0 or 1
  end,
  lower = function(item)
    return item.key:lower()
  end,
  icase = function(item)
    return item.key:lower() == item.key and 0 or 1
  end,
}

---@param nodes wk.Item[]
---@param fields (string|wk.Sorter)[]
function M.sort(nodes, fields)
  table.sort(nodes, function(a, b)
    for _, f in ipairs(fields) do
      local field = type(f) == "function" and f or M.fields[f]
      if field then
        local aa = field(a)
        local bb = field(b)
        if aa ~= bb then
          return aa < bb
        end
      end
    end
    return a.key < b.key
  end)
end

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

---@param field string
---@param value string
---@return string
function M.replace(field, value)
  for _, repl in pairs(Config.ui.replace[field]) do
    value = type(repl) == "function" and (repl(value) or value) or value:gsub(repl[1], repl[2])
  end
  return value
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

  ---@param node wk.Node
  ---@type wk.Item[]
  local items = vim.tbl_map(function(node)
    local child_count = Tree.count(node)
    local desc = node.desc
    if not desc and node.keymap and node.keymap.rhs ~= "" then
      desc = node.keymap.rhs
    end
    if not desc and child_count > 0 then
      desc = child_count .. " keymap" .. (child_count > 1 and "s" or "")
    end
    desc = M.replace("desc", desc or "")
    return setmetatable({
      node = node,
      key = M.replace("key", node.key),
      desc = child_count > 0 and Config.ui.icons.group .. desc or desc,
      group = child_count > 0,
      value = node.value,
    }, { __index = node.data or {} })
  end, children)

  M.sort(items, Config.ui.sort)

  ---@type wk.Col[]
  local cols = {
    { key = "key", hl = "WhichKey", align = "right" },
    { key = "sep", hl = "WhichKeySeparator", default = Config.ui.icons.separator },
  }
  vim.list_extend(cols, state.node.cols or {})
  vim.list_extend(cols, {
    { key = "value", hl = "WhichKeyValue", width = 0.5 },
    { key = "desc", width = 1 },
  })

  local t = Layout.new({
    cols = cols,
    rows = items,
  })

  vim.api.nvim_win_call(M.win, function()
    for r, row in ipairs(t:layout({ width = 120 })) do
      local item = items[r]
      for c, col in ipairs(row) do
        local hl = col.hl
        if cols[c].key == "desc" then
          hl = item.group and "WhichKeyGroup" or "WhichKeyDesc"
        end
        text:append(col.value, hl)
      end
      text:nl()
    end
  end)

  local title = {
    { " " .. table.concat(state.node.path) .. " ", "FloatTitle" },
  }
  if state.node.desc then
    local desc = state.node.desc or ""
    desc = desc:gsub("^%++", "")
    desc = "+" .. desc
    table.insert(title, { " " .. desc .. " ", "FloatTitle" })
  end

  local height = text:height() - 1
  local width = text:width()
  vim.api.nvim_win_set_config(M.win, {
    title = title,
    relative = "editor",
    height = height,
    width = width,
    row = vim.o.lines - height - 3,
    col = vim.o.columns - width,
  })
  text:render(M.buf)
  vim.cmd.redraw()
end

return M
