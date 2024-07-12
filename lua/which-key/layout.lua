local Config = require("which-key.config")
local M = {}

local dw = vim.fn.strdisplaywidth

---@alias wk.Size number|{min:number, max:number}

---@param size number
---@param opts? {parent?: number, min?: number, max?: number}
---@return number
function M.dim(size, opts)
  opts = opts or {}

  if opts.parent then
    assert(type(opts.parent) == "number", "parent must be a number")
    assert(opts.parent > 1, "parent must be greater than 1")
  end

  if math.abs(size) <= 1 then
    assert(opts.parent, "parent is required for relative sizes")
    size = math.floor(size * opts.parent + 0.5)
  end

  if size < 0 then
    assert(opts.parent, "parent is required for relative sizes")
    size = opts.parent + size
  end

  if opts.min then
    local min = M.dim(opts.min, { parent = opts.parent })
    size = math.max(size, min) ---@type number
  end

  if opts.max then
    local max = M.dim(opts.max, { parent = opts.parent })
    size = math.min(size, max) ---@type number
  end

  size = math.max(size, 0)
  size = math.min(size, opts.parent or size)
  return size
end

---@class wk.Col
---@field key string
---@field hl? string
---@field width? number
---@field padding? number[]
---@field default? string
---@field align? "left"|"right"|"center"

---@class wk.Table.opts
---@field cols wk.Col[]
---@field rows table<string, string>[]

---@class wk.Table: wk.Table.opts
local Table = {}
Table.__index = Table

---@param opts wk.Table.opts
function Table.new(opts)
  local self = setmetatable({}, Table)
  self.cols = opts.cols
  self.rows = opts.rows
  return self
end

---@param opts? {spacing?: number}
---@return string[][], number[], number
function Table:cells(opts)
  opts = opts or {}
  opts.spacing = opts.spacing or 1

  local widths = {} ---@type number[] actual column widths

  local cells = {} ---@type string[][]

  local total = 0
  for c, col in ipairs(self.cols) do
    widths[c] = 0
    local all_ws = true
    for r, row in ipairs(self.rows) do
      cells[r] = cells[r] or {}
      local value = row[col.key] or col.default or ""
      value = tostring(value)
      value = value:gsub("%s*$", "")
      value = value:gsub("\n", Config.icons.keys.NL)
      value = vim.fn.strtrans(value)
      if value:find("%S") then
        all_ws = false
      end
      if col.padding then
        value = (" "):rep(col.padding[1] or 0) .. value .. (" "):rep(col.padding[2] or 0)
      end
      if c ~= #self.cols then
        value = value .. (" "):rep(opts.spacing)
      end
      cells[r][c] = value
      widths[c] = math.max(widths[c], dw(value))
    end
    if all_ws then
      widths[c] = 0
      for _, cell in pairs(cells) do
        cell[c] = ""
      end
    end
    total = total + widths[c]
  end

  return cells, widths, total
end

---@param opts {width: number, spacing?: number}
function Table:layout(opts)
  local cells, widths = self:cells(opts)

  local free = opts.width

  for c, col in ipairs(self.cols) do
    if not col.width then
      free = free - widths[c]
    end
  end
  free = math.max(free, 0)

  for c, col in ipairs(self.cols) do
    if col.width then
      widths[c] = M.dim(widths[c], { parent = free, max = col.width })
      free = free - widths[c]
    end
  end

  ---@type {value: string, hl?:string}[][]
  local ret = {}

  for _, row in ipairs(cells) do
    ---@type {value: string, hl?:string}[]
    local line = {}
    for c, col in ipairs(self.cols) do
      local value = row[c]
      local width = dw(value)
      if width > widths[c] then
        local old = value
        value = ""
        for i = 0, vim.fn.strchars(old) do
          value = value .. vim.fn.strcharpart(old, i, 1)
          if dw(value) >= widths[c] - 1 - (opts.spacing or 1) then
            break
          end
        end
        value = value .. Config.icons.ellipsis .. string.rep(" ", opts.spacing or 1)
      else
        local align = col.align or "left"
        if align == "left" then
          value = value .. (" "):rep(widths[c] - width)
        elseif align == "right" then
          value = (" "):rep(widths[c] - width) .. value
        elseif align == "center" then
          local pad = (widths[c] - width) / 2
          value = (" "):rep(math.floor(pad)) .. value .. (" "):rep(math.ceil(pad))
        end
      end
      line[#line + 1] = { value = value, hl = col.hl }
    end
    ret[#ret + 1] = line
  end
  return ret
end

M.new = Table.new

return M
