local Config = require("which-key.config")
local Text = require("which-key.text")

---@class Layout
---@field mapping Mapping
---@field items VisualMapping[]
---@field options Options
---@field text Text
local Layout = {}
Layout.__index = Layout

---@param mappings MappingGroup
---@param options Options
function Layout:new(mappings, options)
  options = options or Config.options
  local this = {
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

function Layout:layout(win)
  local window_width = vim.api.nvim_win_get_width(win)
  local width = window_width
  width = width - self.options.window.padding[2] - self.options.window.padding[4]

  local max_key_width = self:max_width("key")
  local max_label_width = self:max_width("label")
  local max_value_width = self:max_width("value")

  local intro_width = max_key_width + 2 + #self.options.seperator + self.options.layout.spacing
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

  for _, item in pairs(self.items) do
    local start = (col - 1) * column_width + self.options.layout.spacing
    if col == 1 then start = start + pad_left end
    local key = item.key or ""
    if #key < max_key_width then key = string.rep(" ", max_key_width - #key) .. key end

    self.text:set(row + pad_top, start, key, "")
    start = start + #key + 1

    self.text:set(row + pad_top, start, self.options.seperator, "Seperator")
    start = start + #self.options.seperator + 1

    if item.value then
      local value = item.value
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
