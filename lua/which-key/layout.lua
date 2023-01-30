local Config = require("which-key.config")
local Text = require("which-key.text")
local Keys = require("which-key.keys")
local Util = require("which-key.util")

---@class Layout
---@field mapping Mapping
---@field items VisualMapping[]
---@field options Options
---@field text Text
---@field results MappingGroup
local Layout = {}
Layout.__index = Layout

---@param mappings MappingGroup
---@param options? Options
function Layout:new(mappings, options)
  options = options or Config.options
  local this = {
    results = mappings,
    mapping = mappings.mapping,
    items = mappings.mappings,
    options = options,
    text = Text:new(),
  }
  setmetatable(this, self)
  return this
end

function Layout:max_width(key)
  local max = 0
  for _, item in pairs(self.items) do
    if item[key] and Text.len(item[key]) > max then
      max = Text.len(item[key])
    end
  end
  return max
end

function Layout:trail()
  local prefix_i = self.results.prefix_i
  local buf_path = Keys.get_tree(self.results.mode, self.results.buf).tree:path(prefix_i)
  local path = Keys.get_tree(self.results.mode).tree:path(prefix_i)
  local len = #self.results.mapping.keys.notation
  local cmd_line = { { " " } }
  for i = 1, len, 1 do
    local node = buf_path[i]
    if not (node and node.mapping and node.mapping.label) then
      node = path[i]
    end
    local step = self.mapping.keys.notation[i]
    if node and node.mapping and node.mapping.label then
      step = self.options.icons.group .. node.mapping.label
    end
    if Config.options.key_labels[step] then
      step = Config.options.key_labels[step]
    end
    if Config.options.show_keys then
      table.insert(cmd_line, { step, "WhichKeyGroup" })
      if i ~= #self.mapping.keys.notation then
        table.insert(cmd_line, { " " .. self.options.icons.breadcrumb .. " ", "WhichKeySeparator" })
      end
    end
  end
  local width = 0
  if Config.options.show_keys then
    for _, line in pairs(cmd_line) do
      width = width + Text.len(line[1])
    end
  end
  local help = { --
    ["<bs>"] = "go up one level",
    ["<esc>"] = "close",
  }
  if #self.text.lines > self.options.layout.height.max then
    help[Config.options.popup_mappings.scroll_down] = "scroll down"
    help[Config.options.popup_mappings.scroll_up] = "scroll up"
  end
  local help_line = {}
  local help_width = 0
  for key, label in pairs(help) do
    help_width = help_width + Text.len(key) + Text.len(label) + 2
    table.insert(help_line, { key .. " ", "WhichKey" })
    table.insert(help_line, { label .. " ", "WhichKeySeparator" })
  end
  if Config.options.show_keys then
    table.insert(cmd_line, { string.rep(" ", math.floor(vim.o.columns / 2 - help_width / 2) - width) })
  end

  if self.options.show_help then
    for _, l in pairs(help_line) do
      table.insert(cmd_line, l)
    end
  end
  if vim.o.cmdheight > 0 then
    vim.api.nvim_echo(cmd_line, false, {})
    vim.cmd([[redraw]])
  else
    local col = 1
    self.text:nl()
    local row = #self.text.lines
    for _, text in ipairs(cmd_line) do
      self.text:set(row, col, text[1], text[2] and text[2]:gsub("WhichKey", "") or nil)
      col = col + vim.fn.strwidth(text[1])
    end
  end
end

function Layout:layout(win)
  local pad_top, pad_right, pad_bot, pad_left = unpack(self.options.window.padding)
  local window_width = vim.api.nvim_win_get_width(win)
  local width = window_width
  width = width - pad_right - pad_left

  local max_key_width = self:max_width("key")
  local max_label_width = self:max_width("label")
  local max_value_width = self:max_width("value")

  local intro_width = max_key_width + 2 + Text.len(self.options.icons.separator) + self.options.layout.spacing
  local max_width = max_label_width + intro_width + max_value_width
  if max_width > width then
    max_width = width
  end

  local column_width = max_width

  if max_value_width == 0 then
    if column_width > self.options.layout.width.max then
      column_width = self.options.layout.width.max
    end
    if column_width < self.options.layout.width.min then
      column_width = self.options.layout.width.min
    end
  else
    max_value_width = math.min(max_value_width, math.floor((column_width - intro_width) / 2))
  end

  max_label_width = column_width - (intro_width + max_value_width)

  local columns = math.floor(width / column_width)

  local height = math.ceil(#self.items / columns)
  if height < self.options.layout.height.min then
    height = self.options.layout.height.min
  end
  -- if height > self.options.layout.height.max then height = self.options.layout.height.max end

  local col = 1
  local row = 1

  local columns_used = math.min(columns, math.ceil(#self.items / height))
  local offset_x = 0
  if columns_used < columns then
    if self.options.layout.align == "right" then
      offset_x = (columns - columns_used) * column_width
    elseif self.options.layout.align == "center" then
      offset_x = math.floor((columns - columns_used) * column_width / 2)
    end
  end

  for _, item in pairs(self.items) do
    local start = (col - 1) * column_width + self.options.layout.spacing + offset_x + pad_left
    local key = item.key or ""
    if key == "<lt>" then
      key = "<"
    end
    if key == Util.t("<esc>") then
      key = "<esc>"
    end
    if Text.len(key) < max_key_width then
      key = string.rep(" ", max_key_width - Text.len(key)) .. key
    end

    self.text:set(row + pad_top, start, key, "")
    start = start + Text.len(key) + 1

    self.text:set(row + pad_top, start, self.options.icons.separator, "Separator")
    start = start + Text.len(self.options.icons.separator) + 1

    if item.value then
      local value = item.value
      start = start + 1
      if Text.len(value) > max_value_width then
        value = vim.fn.strcharpart(value, 0, max_value_width - 2) .. " …"
      end
      self.text:set(row + pad_top, start, value, "Value")
      if item.highlights then
        for _, hl in pairs(item.highlights) do
          self.text:highlight(row + pad_top, start + hl[1] - 1, start + hl[2] - 1, hl[3])
        end
      end
      start = start + max_value_width + 2
    end

    local label = item.label
    if Text.len(label) > max_label_width then
      label = vim.fn.strcharpart(label, 0, max_label_width - 2) .. " …"
    end
    self.text:set(row + pad_top, start, label, item.group and "Group" or "Desc")

    if row % height == 0 then
      col = col + 1
      row = 1
    else
      row = row + 1
    end
  end

  for _ = 1, pad_bot, 1 do
    self.text:nl()
  end
  self:trail()
  return self.text
end

return Layout
