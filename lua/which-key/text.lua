local Util = require("which-key.util")

---@class wk.Segment
---@field str string Text
---@field hl? string Extmark hl group
---@field line? number line number in a multiline segment
---@field width? number

---@class wk.Text.opts
---@field multiline? boolean
---@field indent? boolean

---@class wk.Text
---@field _lines wk.Segment[][]
---@field _col number
---@field _indents string[]
---@field _opts wk.Text.opts
local M = {}
M.__index = M

M.ns = vim.api.nvim_create_namespace("wk.text")

---@param opts? wk.Text.opts
function M.new(opts)
  local self = setmetatable({}, M)
  self._lines = {}
  self._col = 0
  self._opts = opts or {}
  self._indents = {}
  for i = 0, 100, 1 do
    self._indents[i] = (" "):rep(i)
  end
  return self
end

function M:height()
  return #self._lines
end

---@return number
function M:width()
  local width = 0
  for _, line in ipairs(self._lines) do
    local w = 0
    for _, segment in ipairs(line) do
      w = w + vim.fn.strdisplaywidth(segment.str)
    end
    width = math.max(width, w)
  end
  return width
end

---@param text string|wk.Segment[]
---@param opts? string|{hl?:string, line?:number}
function M:append(text, opts)
  opts = opts or {}
  if #self._lines == 0 then
    self:nl()
  end

  if type(text) == "table" then
    for _, s in ipairs(text) do
      s.width = s.width or #s.str
      self._col = self._col + s.width
      table.insert(self._lines[#self._lines], s)
    end
    return self
  end

  opts = type(opts) == "string" and { hl = opts } or opts

  for l, line in ipairs(vim.split(text, "\n", { plain = true })) do
    local width = #line
    self._col = self._col + width
    table.insert(self._lines[#self._lines], {
      str = line,
      width = width,
      hl = opts.hl,
      line = opts.line or l,
    })
  end
  return self
end

function M:nl()
  table.insert(self._lines, {})
  self._col = 0
  return self
end

---@param opts? {sep?:string}
function M:statusline(opts)
  local sep = opts and opts.sep or " "
  local lines = {} ---@type string[]
  for _, line in ipairs(self._lines) do
    local parts = {}
    for _, segment in ipairs(line) do
      local str = segment.str:gsub("%%", "%%%%")
      if segment.hl then
        str = ("%%#%s#%s%%*"):format(segment.hl, str)
      end
      parts[#parts + 1] = str
    end
    table.insert(lines, table.concat(parts, ""))
  end
  return table.concat(lines, sep)
end

function M:render(buf)
  local lines = {}

  for _, line in ipairs(self._lines) do
    local parts = {} ---@type string[]
    for _, segment in ipairs(line) do
      parts[#parts + 1] = segment.str
    end
    table.insert(lines, table.concat(parts, ""))
  end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_clear_namespace(buf, M.ns, 0, -1)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  for l, line in ipairs(self._lines) do
    local col = 0
    local row = l - 1

    for _, segment in ipairs(line) do
      local width = segment.width
      if segment.hl then
        Util.set_extmark(buf, M.ns, row, col, {
          hl_group = segment.hl,
          end_col = col + width,
        })
      end
      col = col + width
    end
  end
  vim.bo[buf].modifiable = false
end

function M:trim()
  while #self._lines > 0 and #self._lines[#self._lines] == 0 do
    table.remove(self._lines)
  end
end

function M:row()
  return #self._lines == 0 and 1 or #self._lines
end

---@param opts? {display:boolean}
function M:col(opts)
  if opts and opts.display then
    local ret = 0
    for _, segment in ipairs(self._lines[#self._lines] or {}) do
      ret = ret + vim.fn.strdisplaywidth(segment.str)
    end
    return ret
  end
  return self._col
end

return M
