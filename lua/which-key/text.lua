---@class Highlight
---@field group string
---@field line number
---@field from number
---@field to number

---@class Text
---@field lines string[]
---@field hl Highlight[]
---@field lineNr number
---@field current string
local Text = {}
Text.__index = Text

function Text.len(str)
  return vim.fn.strwidth(str)
end

function Text:new()
  local this = { lines = {}, hl = {}, lineNr = 0, current = "" }
  setmetatable(this, self)
  return this
end

function Text:fix_nl(line)
  return line:gsub("[\n]", "")
end

function Text:nl()
  local line = self:fix_nl(self.current)
  table.insert(self.lines, line)
  self.current = ""
  self.lineNr = self.lineNr + 1
end

function Text:set(row, col, str, group)
  str = self:fix_nl(str)

  -- extend lines if needed
  for i = 1, row, 1 do
    if not self.lines[i] then
      self.lines[i] = ""
    end
  end

  -- extend columns when needed
  local width = Text.len(self.lines[row])
  if width < col then
    self.lines[row] = self.lines[row] .. string.rep(" ", col - width)
  end

  local before = vim.fn.strcharpart(self.lines[row], 0, col)
  local after = vim.fn.strcharpart(self.lines[row], col)
  self.lines[row] = before .. str .. after

  if not group then
    return
  end
  -- set highlights
  self:highlight(row, col, col + Text.len(str), "WhichKey" .. group)
end

function Text:highlight(row, from, to, group)
  local line = self.lines[row]
  local before = vim.fn.strcharpart(line, 0, from)
  local str = vim.fn.strcharpart(line, 0, to)
  from = vim.fn.strlen(before)
  to = vim.fn.strlen(str)
  table.insert(self.hl, { line = row - 1, from = from, to = to, group = group })
end

return Text
