local Buf = require("which-key.buf")
local Config = require("which-key.config")
local Icons = require("which-key.icons")
local Layout = require("which-key.layout")
local Plugins = require("which-key.plugins")
local State = require("which-key.state")
local Tree = require("which-key.tree")
local Util = require("which-key.util")

local M = {}
M.buf = nil ---@type number
M.win = nil ---@type number
M.timer = vim.uv.new_timer()

---@class wk.Item: wk.Node
---@field node wk.Node
---@field key string
---@field desc string
---@field group? boolean
---@field order? number

---@alias wk.Sorter fun(node:wk.Item): (string|number)

---@type table<string, wk.Sorter>
M.fields = {
  order = function(item)
    return item.order and item.order or 1000
  end,
  ["local"] = function(item)
    return item.keymap and item.keymap.buffer ~= 0 and 0 or 1000
  end,
  manual = function(item)
    return item.virtual and item.virtual.idx or 10000
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

M.icons = {
  Up = " ",
  Down = " ",
  Left = " ",
  Right = " ",
  C = "󰘴 ",
  M = "󰘵 ",
  S = "󰘶 ",
  CR = "󰌑 ",
  Esc = "󱊷 ",
  ScrollWheelDown = "󱕐 ",
  ScrollWheelUp = "󱕑 ",
  NL = "󰌑 ",
  BS = "⌫",
  Space = "󱁐 ",
  Tab = "󰌒 ",
}

---@param key string
function M.format(key)
  local inner = key:match("^<(.*)>$")
  if not inner then
    return key
  end
  local parts = vim.split(inner, "-", { plain = true })
  parts[1] = M.icons[parts[1]] or parts[1]
  if parts[2] and not parts[2]:match("^%w$") then
    parts[2] = M.icons[parts[2]] or parts[2]
  end
  return table.concat(parts, "")
end

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

function M.valid()
  return M.buf and vim.api.nvim_buf_is_valid(M.buf) and M.win and vim.api.nvim_win_is_valid(M.win) or false
end

---@param opts? {delay?: number, schedule?: boolean}
function M.update(opts)
  local state = State.state

  if not state then
    M.hide()
    return
  end

  opts = opts or {}
  if M.valid() then
    M.show()
  elseif opts.schedule ~= false then
    local delay = opts.delay
      or type(Config.delay) == "function" and Config.delay({
        mode = state.mode.mode,
        keys = state.node.keys,
        plugin = state.node.plugin,
      })
      or Config.delay --[[@as number]]
    M.timer:start(
      delay,
      0,
      vim.schedule_wrap(function()
        Util.try(M.show)
      end)
    )
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

function M.opts()
  return vim.tbl_deep_extend("force", Config.win, {
    relative = "editor",
    style = "minimal",
    focusable = false,
    noautocmd = true,
    wo = {
      scrolloff = 0,
    },
    bo = {
      buftype = "nofile",
      bufhidden = "wipe",
      filetype = "wk",
    },
  })
end

---@param opts wk.Win
function M.mount(opts)
  local win_opts = vim.deepcopy(opts)
  win_opts.wo = nil
  win_opts.bo = nil
  win_opts.padding = nil

  if M.valid() then
    win_opts.noautocmd = nil
    return vim.api.nvim_win_set_config(M.win, win_opts)
  end

  M.buf = vim.api.nvim_create_buf(false, true)
  M.set_options("buf", opts.bo)
  M.win = vim.api.nvim_open_win(M.buf, false, win_opts)
  M.set_options("win", opts.wo)
end

---@param field string
---@param value string
---@return string
function M.replace(field, value)
  for _, repl in pairs(Config.replace[field]) do
    value = type(repl) == "function" and (repl(value) or value) or value:gsub(repl[1], repl[2])
  end
  return value
end

---@param node wk.Node
---@param opts? {default?: "count"|"path", parent_key?: string}
function M.item(node, opts)
  opts = opts or {}
  opts.default = opts.default or "count"
  local child_count = Tree.count(node)
  local desc = node.desc
  if not desc and node.keymap and node.keymap.rhs ~= "" then
    desc = node.keymap.rhs
  end
  if not desc and opts.default == "count" and child_count > 0 then
    desc = child_count .. " keymap" .. (child_count > 1 and "s" or "")
  end
  if not desc and opts.default == "path" then
    desc = node.keys
  end
  desc = M.replace("desc", desc or "")
  local icon, icon_hl = Icons.get({ keymap = node.keymap, desc = node.desc })
  local parent_key = opts.parent_key and M.replace("key", opts.parent_key) or ""
  ---@type wk.Item
  return setmetatable({
    node = node,
    icon = icon,
    icon_hl = icon_hl,
    key = parent_key .. M.replace("key", node.key),
    desc = child_count > 0 and Config.icons.group .. desc or desc,
    group = child_count > 0,
  }, { __index = node })
end

---@param node wk.Node
---@param opts? {title?: boolean}
function M.trail(node, opts)
  opts = opts or {}
  local trail = {} ---@type string[][]
  while node do
    local desc = node.desc and (Config.icons.group .. M.replace("desc", node.desc))
      or node.key and M.replace("key", node.key)
      or ""
    node = node.parent
    if desc ~= "" then
      if node and #trail > 0 then
        table.insert(trail, 1, {
          " " .. Config.icons.breadcrumb .. " ",
          opts.title and "WhichKeyTitle" or "WhichKeySeparator",
        })
      end
      table.insert(trail, 1, { desc, opts.title and "WhichKeyTitle" or "WhichKeyGroup" })
    end
  end
  if #trail > 0 then
    table.insert(trail, 1, { " " })
    table.insert(trail, { " " })
    return trail
  end
end

function M.show()
  local state = State.state
  if not state or not state.node.children then
    M.hide()
    return
  end
  local text = require("which-key.text").new()

  ---@type wk.Node[]
  local children = vim.tbl_values(state.node.children or {})

  ---@type wk.Item[]
  local items = {}
  for _, node in ipairs(children) do
    local use = true
    if state.filter.global == false and node.global then
      use = false
    end
    if state.filter["local"] == false and not node.global then
      use = false
    end
    if use then
      local child_count = Tree.count(node)
      if child_count > 0 and child_count <= Config.expand then
        for _, child in ipairs(vim.tbl_values(node.children or {})) do
          table.insert(items, M.item(child, { parent_key = node.key }))
        end
      else
        table.insert(items, M.item(node))
      end
    end
  end

  M.sort(items, Config.sort)

  ---@type wk.Col[]
  local cols = {
    { key = "key", hl = "WhichKey", align = "right" },
    { key = "sep", hl = "WhichKeySeparator", default = Config.icons.separator },
    { key = "icon", padding = { 0, 0 } },
  }
  if state.node.plugin then
    vim.list_extend(cols, Plugins.cols(state.node.plugin))
  end
  cols[#cols + 1] = { key = "desc", width = 1 }

  local t = Layout.new({ cols = cols, rows = items })

  local opts = M.opts()
  local container = {
    width = M.dim(opts.width, vim.o.columns),
    height = M.dim(opts.height, vim.o.lines),
  }
  local _, _, max_row_width = t:cells()
  local box_width = M.dim(Config.layout.width, container.width, max_row_width)
  local box_count = math.max(math.floor(container.width / (box_width + Config.layout.spacing)), 1)
  box_width = math.floor(container.width / box_count)
  local box_height = math.max(math.ceil(#items / box_count), 2)

  local rows = t:layout({ width = box_width - Config.layout.spacing })

  for _ = 1, Config.options.win.padding[1] + 1 do
    text:nl()
  end

  for l = 1, box_height do
    text:append(string.rep(" ", Config.win.padding[2]))
    for b = 1, box_count do
      local i = (b - 1) * box_height + l
      local item = items[i]
      local row = rows[i]
      text:append(string.rep(" ", Config.layout.spacing))
      if item then
        for c, col in ipairs(row) do
          local hl = col.hl
          if cols[c].key == "desc" then
            hl = item.group and "WhichKeyGroup" or "WhichKeyDesc"
          end
          if cols[c].key == "icon" then
            hl = item.icon_hl
          end
          text:append(col.value, hl)
        end
      end
    end
    text:nl()
  end
  text:trim()

  for _ = 1, Config.options.win.padding[1] do
    text:nl()
  end

  local show_keys = Config.show_keys

  local has_border = opts.border and opts.border ~= "none"
  if not has_border then
    opts.footer = nil
    opts.title = nil
  end
  if opts.title == true then
    opts.title = M.trail(state.node, { title = true })
    show_keys = false
  end
  if opts.footer == true then
    opts.footer = M.trail(state.node, { title = true })
    show_keys = false
  end
  if not opts.title then
    opts.title = nil
    opts.title_pos = nil
  end
  if not opts.footer then
    opts.footer = nil
    opts.footer_pos = nil
  end

  local bw = has_border and 2 or 0

  opts.width = M.dim(opts.width, vim.o.columns, text:width() + bw)
  opts.height = M.dim(opts.height, vim.o.lines, text:height() + bw)
  if Config.show_help then
    opts.height = opts.height + 1
  end

  opts.col = Layout.dim(opts.col, { parent = vim.o.columns })
  opts.row = opts.row < 0 and vim.o.lines + opts.row - opts.height or opts.row
  opts.width = opts.width - bw
  opts.height = opts.height - bw
  M.mount(opts)

  if Config.show_help or show_keys then
    text:nl()
  end
  if show_keys then
    text:append(" ")
    for _, segment in ipairs(M.trail(state.node) or {}) do
      text:append(segment[1], segment[2])
    end
  end
  if Config.show_help then
    local col = text:col({ display = true })
    local ws = string.rep(" ", math.floor((opts.width - 30) / 2) - col)
    text:append(ws)
    text:append("<esc>", "WhichKey"):append(" close", "WhichKeySeparator")
    text:append(" ")
    text:append("<bs>", "WhichKey"):append(" go up a level", "WhichKeySeparator")
  end

  text:render(M.buf)
  vim.api.nvim_win_call(M.win, function()
    vim.fn.winrestview({ topline = 1 })
  end)
  vim.cmd.redraw()
end

---@param size wk.Size
---@param parent wk.Size
---@param preferred? wk.Size
function M.dim(size, parent, preferred)
  preferred = preferred or parent
  ---@type {parent?: number, min?: number, max?: number}
  local opts = type(size) == "table" and size or {}
  opts.parent = parent
  size = type(size) == "table" and preferred or size
  ---@cast size number
  return Layout.dim(size, opts)
end

---@param up boolean
function M.scroll(up)
  assert(M.valid(), "invalid view")
  local height = vim.api.nvim_win_get_height(M.win)
  local delta = math.ceil((up and -1 or 1) * height / 2)
  local view = vim.api.nvim_win_call(M.win, vim.fn.winsaveview)
  local top = view.topline ---@type number
  top = top + delta
  top = math.max(top, 1)
  top = math.min(top, vim.api.nvim_buf_line_count(M.buf) - height + 1)
  vim.api.nvim_win_call(M.win, function()
    vim.fn.winrestview({ topline = top, lnum = top })
  end)
end

---@param type "win" | "buf"
---@param opts vim.wo | vim.bo
function M.set_options(type, opts)
  ---@diagnostic disable-next-line: no-unknown
  for k, v in pairs(opts or {}) do
    ---@diagnostic disable-next-line: no-unknown
    local ok, err = pcall(vim.api.nvim_set_option_value, k, v, type == "win" and {
      scope = "local",
      win = M.win,
    } or { buf = M.buf })
    if not ok then
      Util.error("Error setting option `" .. k .. "=" .. v .. "`\n\n" .. err)
    end
  end
end

return M
