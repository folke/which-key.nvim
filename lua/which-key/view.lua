local Buf = require("which-key.buf")
local Config = require("which-key.config")
local Icons = require("which-key.icons")
local Layout = require("which-key.layout")
local Plugins = require("which-key.plugins")
local State = require("which-key.state")
local Text = require("which-key.text")
local Tree = require("which-key.tree")
local Util = require("which-key.util")
local Win = require("which-key.win")

local M = {}
M.view = nil ---@type wk.Win?
M.footer = nil ---@type wk.Win?
M.timer = (vim.uv or vim.loop).new_timer()

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
    return item.mapping and item.mapping.idx or 10000
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
  case = function(item)
    return item.key:lower() == item.key and 0 or 1
  end,
  natural = function(item)
    local ret = item.key:gsub("%d+", function(d)
      return ("%09d"):format(tonumber(d))
    end)
    return ret:lower()
  end,
}

---@param lhs string
function M.format(lhs)
  local keys = Util.keys(lhs)
  local ret = vim.tbl_map(function(key)
    local inner = key:match("^<(.*)>$")
    if not inner then
      return key
    end
    if inner == "NL" then
      inner = "C-J"
    end
    local parts = vim.split(inner, "-", { plain = true })
    for i, part in ipairs(parts) do
      if i == 1 or i ~= #parts or not part:match("^%w$") then
        parts[i] = Config.icons.keys[part] or parts[i]
      end
    end
    return table.concat(parts, "")
  end, keys)
  return table.concat(ret, "")
end

---@param nodes wk.Item[]
---@param fields? (string|wk.Sorter)[]
function M.sort(nodes, fields)
  fields = vim.deepcopy(fields or Config.sort)
  vim.list_extend(fields, { "natural", "case" })
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
    return a.raw_key < b.raw_key
  end)
end

function M.valid()
  return M.view and M.view:valid()
end

---@param opts? {delay?: number, schedule?: boolean, waited?: number}
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
      or State.delay({
        mode = state.mode.mode,
        keys = state.node.keys,
        plugin = state.node.plugin,
        waited = opts.waited,
      })
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
  if M.view then
    M.view:hide()
    M.view = nil
  end
  if M.footer then
    M.footer:hide()
    M.footer = nil
  end
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
function M.icon(node)
  -- plugin items should not get icons
  if node.parent and node.parent.plugin then
    return
  end
  if node.mapping and node.mapping.icon then
    return Icons.get(node.mapping.icon)
  end
  local icon, icon_hl = Icons.get({ keymap = node.keymap, desc = node.desc })
  if icon then
    return icon, icon_hl
  end
  if node.parent then
    return M.icon(node.parent)
  end
end

---@param node wk.Node
---@param opts? {default?: "count"|"path", parent?: wk.Node, group?: boolean}
function M.item(node, opts)
  opts = opts or {}
  opts.default = opts.default or "count"
  local child_count = (node:can_expand() or opts.group == false) and 0 or node:count()
  local desc = node.desc
  if not desc and node.keymap and node.keymap.rhs ~= "" and type(node.keymap.rhs) == "string" then
    desc = node.keymap.rhs --[[@as string]]
  end
  if not desc and opts.default == "count" and child_count > 0 then
    desc = child_count .. " keymap" .. (child_count > 1 and "s" or "")
  end
  if not desc and opts.default == "path" then
    desc = node.keys
  end
  desc = M.replace("desc", desc or "")
  local icon, icon_hl = M.icon(node)

  local raw_key = node.key
  if opts.parent and opts.parent ~= node and node.keys:find(opts.parent.keys, 1, true) == 1 then
    raw_key = node.keys:sub(opts.parent.keys:len() + 1)
  end

  local group = node:is_group()
  ---@type wk.Item
  return setmetatable({
    node = node,
    icon = icon or "",
    icon_hl = icon_hl,
    key = M.replace("key", raw_key),
    raw_key = raw_key,
    desc = group and Config.icons.group .. desc or desc,
    group = group,
  }, { __index = node })
end

---@param node wk.Node
---@param opts? {title?: boolean}
function M.trail(node, opts)
  opts = opts or {}

  ---@param group? string
  local function hl(group)
    return opts.title and "WhichKeyTitle" or (group and ("WhichKey" .. group) or "WhichKeyGroup")
  end

  local trail = {} ---@type string[][]
  local did_op = false
  while node do
    local desc = node.desc and (Config.icons.group .. M.replace("desc", node.desc))
      or node.key and M.replace("key", node.key)
      or ""
    node = node.parent
    if desc ~= "" then
      if node and #trail > 0 then
        table.insert(trail, 1, { " " .. Config.icons.breadcrumb .. " ", hl("Separator") })
      end
      table.insert(trail, 1, { desc, hl() })
    end
    local m = State.state.mode.mode
    if not did_op and not node and (m == "x" or m == "o") then
      did_op = true
      local mode = Buf.get({ buf = State.state.mode.buf.buf, mode = "n" })
      if mode then
        node = mode.tree:find(m == "x" and "v" or vim.v.operator)
      end
    end
  end
  if #trail > 0 then
    table.insert(trail, 1, { " ", hl() })
    table.insert(trail, { " ", hl() })
    return trail
  end
end

---@param root wk.Node
---@param node wk.Node
---@param expand fun(node:wk.Node): boolean
---@param filter fun(node:wk.Node): boolean
---@param ret? wk.Item[]
function M.expand(root, node, expand, filter, ret)
  ret = ret or {}
  if not filter(node) then
    return ret
  end
  if not node:is_plugin() and expand(node) then
    if node.keymap then
      ret[#ret + 1] = M.item(node, { group = false, parent = root })
    end
    for _, child in ipairs(node:children()) do
      M.expand(root, child, expand, filter, ret)
    end
  else
    ret[#ret + 1] = M.item(node, { parent = root })
  end
  return ret
end

function M.show()
  local state = State.state
  if not (state and state.show and state.node:is_group()) then
    M.hide()
    return
  end
  local text = Text.new()

  ---@type wk.Node[]
  local children = state.node:children()

  if state.filter.global == false and state.filter.expand == nil then
    state.filter.expand = true
  end

  ---@param node wk.Node
  local function filter(node)
    local l = state.filter["local"] ~= false
    local g = state.filter.global ~= false
    if not g and not l then
      return false
    end
    if g and l then
      return true
    end
    local is_local = node:is_local()
    return l and is_local or g and not is_local
  end

  ---@param node wk.Node
  local function expand(node)
    if node:is_plugin() then
      return false
    end
    if state.filter.expand then
      return true
    end
    if node:can_expand() then
      return false
    end
    if type(Config.expand) == "function" then
      return Config.expand(node)
    end
    local child_count = node:count()
    return child_count > 0 and child_count <= Config.expand
  end

  ---@type wk.Item[]
  local items = {}
  for _, node in ipairs(children) do
    vim.list_extend(items, M.expand(state.node, node, expand, filter))
  end

  M.sort(items)

  ---@type wk.Col[]
  local cols = {
    { key = "key", hl = "WhichKey", align = "right" },
    { key = "sep", hl = "WhichKeySeparator", default = Config.icons.separator },
    { key = "icon", padding = { 0, 0 } },
  }
  if state.node.plugin then
    vim.list_extend(cols, Plugins.cols(state.node.plugin))
  end
  cols[#cols + 1] = { key = "desc", width = math.huge }

  local t = Layout.new({ cols = cols, rows = items })

  local opts = Win.defaults(Config.win)
  local container = {
    width = Layout.dim(vim.o.columns, vim.o.columns, opts.width),
    height = Layout.dim(vim.o.lines, vim.o.lines, opts.height),
  }
  local _, _, max_row_width = t:cells()
  local box_width = Layout.dim(max_row_width, container.width, Config.layout.width)
  local box_count = math.max(math.floor(container.width / (box_width + Config.layout.spacing)), 1)
  box_width = math.floor(container.width / box_count)
  local box_height = math.max(math.ceil(#items / box_count), 2)

  local rows = t:layout({ width = box_width - Config.layout.spacing })

  for _ = 1, Config.win.padding[1] + 1 do
    text:nl()
  end

  for l = 1, box_height do
    text:append(string.rep(" ", Config.win.padding[2]))
    for b = 1, box_count do
      local i = (b - 1) * box_height + l
      local item = items[i]
      local row = rows[i]
      if b ~= 1 or box_count > 1 then
        text:append(string.rep(" ", Config.layout.spacing))
      end
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
    text:append(string.rep(" ", Config.win.padding[2]))
    text:nl()
  end
  text:trim()

  for _ = 1, Config.win.padding[1] do
    text:nl()
  end

  local show_keys = Config.show_keys

  local has_border = opts.border and opts.border ~= "none"
  if has_border then
    if opts.title == true then
      opts.title = M.trail(state.node, { title = true })
      show_keys = false
    end
    if opts.footer == true then
      opts.footer = M.trail(state.node, { title = true })
      show_keys = false
    end
    if not opts.title then
      opts.title = ""
      opts.title_pos = nil
    end
    if not opts.footer then
      opts.footer = ""
      opts.footer_pos = nil
    end
  else
    opts.footer = nil
    opts.footer_pos = nil
    opts.title = nil
    opts.title_pos = nil
  end

  local bw = has_border and 2 or 0

  opts.width = Layout.dim(text:width() + bw, vim.o.columns, opts.width)
  opts.height = Layout.dim(text:height() + bw, vim.o.lines, opts.height)

  if Config.show_help then
    opts.height = opts.height + 1
  end

  -- top-left
  opts.col = Layout.dim(opts.col, vim.o.columns - opts.width)
  opts.row = Layout.dim(opts.row, vim.o.lines - opts.height - vim.o.cmdheight)

  opts.width = opts.width - bw
  opts.height = opts.height - bw
  M.check_overlap(opts)

  M.view = M.view or Win.new(opts)
  M.view:show(opts)

  if Config.show_help or show_keys then
    text:nl()
    local footer = Text.new()
    if show_keys then
      footer:append(" ")
      for _, segment in ipairs(M.trail(state.node) or {}) do
        footer:append(segment[1], segment[2])
      end
    end
    if Config.show_help then
      ---@type {key: string, desc: string}[]
      local keys = {
        { key = "<esc>", desc = "close" },
      }
      if state.node.parent then
        keys[#keys + 1] = { key = "<bs>", desc = "back" }
      end
      if opts.height < text:height() then
        keys[#keys + 1] = { key = Config.keys.scroll_down .. "/" .. Config.keys.scroll_up, desc = "scroll" }
      end
      local help = Text.new()
      for k, key in ipairs(keys) do
        help:append(M.replace("key", Util.norm(key.key)), "WhichKey"):append(" " .. key.desc, "WhichKeySeparator")
        if k < #keys then
          help:append("  ")
        end
      end
      local col = footer:col({ display = true })
      local ws = string.rep(" ", math.floor((opts.width - help:width()) / 2) - col)
      footer:append(ws)
      footer:append(help._lines[1])
    end
    footer:trim()
    M.footer = M.footer or Win.new()
    M.footer:show({
      relative = "win",
      win = M.view.win,
      col = 0,
      row = opts.height - 1,
      width = opts.width,
      height = 1,
      zindex = M.view.opts.zindex + 1,
      border = "none",
    })
    footer:render(M.footer.buf)
  end

  text:render(M.view.buf)
  vim.api.nvim_win_call(M.view.win, function()
    vim.fn.winrestview({ topline = 1 })
  end)
  vim.cmd.redraw()
end

---@param opts wk.Win.opts
function M.check_overlap(opts)
  if Config.win.no_overlap == false then
    return
  end
  local row, col = vim.fn.screenrow(), vim.fn.screencol()
  local overlaps = (row >= opts.row and row <= opts.row + opts.height)
    and (col >= opts.col and col <= opts.col + opts.width)
  -- dd(overlaps and "overlaps" or "no overlap", {
  --   editor = { lines = vim.o.lines, columns = vim.o.columns },
  --   cursor = { col = col, row = row },
  --   win = { row = opts.row, col = opts.col, height = opts.height, width = opts.width },
  --   overlaps = overlaps,
  -- })
  if overlaps then
    opts.row = row + 1
    opts.height = math.max(vim.o.lines - opts.row, 4)
  end
end

---@param up boolean
function M.scroll(up)
  return M.view and M.view:scroll(up)
end

return M
