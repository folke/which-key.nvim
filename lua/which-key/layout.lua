local Config = require("which-key.config")
local Text = require("which-key.text")
local Keys = require("which-key.keys")

---@class Layout
---@field mapping Mapping
---@field items VisualMapping[]
---@field options Options
---@field text Text
---@field results MappingGroup
local Layout = {}
Layout.__index = Layout

---@param mappings MappingGroup
---@param options Options
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
  for _, item in pairs(self.items) do if item[key] and #item[key] > max then max = #item[key] end end
  return max
end

function Layout:trail()
  local prefix = self.results.prefix
  local cmd_line = { { " " } }
  for i = 1, #self.mapping.keys.nvim, 1 do
    local offset = #self.mapping.keys.nvim - i
    local node = Keys.get_tree(self.results.mode, self.results.buf).tree:get(prefix, offset)
    if not (node and node.mapping and node.mapping.label) then
      node = Keys.get_tree(self.results.mode).tree:get(prefix, offset)
    end
    local step = self.mapping.keys.nvim[i]
    if node and node.mapping and node.mapping.label then
      step = self.options.icons.group .. node.mapping.label
    end
    table.insert(cmd_line, { step, "WhichKeyGroup" })
    if i ~= #self.mapping.keys.nvim then
      table.insert(cmd_line, { " " .. self.options.icons.breadcrumb .. " ", "WhichKeySeparator" })
    end
  end
  local width = 0
  for _, line in pairs(cmd_line) do width = width + Text.len(line[1]) end
  local help = { --
    ["<bs>"] = "go up one level",
    ["<c-d>"] = "scroll down",
    ["<c-u>"] = "scroll up",
    ["<esc>"] = "close",
  }
  local help_line = {}
  local help_width = 0
  for key, label in pairs(help) do
    help_width = help_width + Text.len(key) + Text.len(label) + 2
    table.insert(help_line, { key .. " ", "WhichKey" })
    table.insert(help_line, { label .. " ", "WhichKeySeparator" })
  end
  table.insert(cmd_line, { string.rep(" ", math.floor(vim.o.columns / 2 - help_width / 2) - width) })

  for _, l in pairs(help_line) do table.insert(cmd_line, l) end
  vim.api.nvim_echo(cmd_line, false, {})
end

function Layout:layout(win)
  local window_width = vim.api.nvim_win_get_width(win)
  local width = window_width
  width = width - self.options.window.padding[2] - self.options.window.padding[4]

  local max_key_width = self:max_width("key")
  local max_label_width = self:max_width("label")
  local max_value_width = self:max_width("value")

  local intro_width = max_key_width + 2 + #self.options.icons.separator +
                        self.options.layout.spacing
  local max_width = max_label_width + intro_width + max_value_width
  if max_width > width then max_width = width end

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
  if height < self.options.layout.height.min then height = self.options.layout.height.min end
  -- if height > self.options.layout.height.max then height = self.options.layout.height.max end

  local col = 1
  local row = 1
  local pad_top = self.options.window.padding[3]
  local pad_left = self.options.window.padding[4]

  self:trail()

  for _, item in pairs(self.items) do
    local start = (col - 1) * column_width + self.options.layout.spacing
    if col == 1 then start = start + pad_left end
    local key = item.key or ""
    if key == "<lt>" then key = "<" end
    if #key < max_key_width then key = string.rep(" ", max_key_width - #key) .. key end

    self.text:set(row + pad_top, start, key, "")
    start = start + #key + 1

    self.text:set(row + pad_top, start, self.options.icons.separator, "Separator")
    start = start + #self.options.icons.separator + 1

    if item.value then
      local value = item.value
      start = start + 1
      if Text.len(value) > max_value_width then
        value = value:sub(0, max_value_width - 4) .. " ..."
      end
      self.text:set(row + pad_top, start, value, "Value")
      if item.highlights then
        for _, hl in pairs(item.highlights) do
          self.text:highlight(row + pad_top - 1, start + hl[1] - 1, start + hl[2] - 1, hl[3])
        end
      end
      start = start + max_value_width + 2
    end

    local label = item.label
    if Text.len(label) > max_label_width then label = label:sub(0, max_label_width - 4) .. " ..." end
    self.text:set(row + pad_top, start, label, item.group and "Group" or "Desc")

    if row % height == 0 then
      col = col + 1
      row = 1
    else
      row = row + 1
    end
  end

  for _ = 1, self.options.window.padding[3], 1 do self.text:nl() end
  return self.text
end

return Layout
