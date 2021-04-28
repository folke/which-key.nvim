local config = require("which-key.config")

---@class Text
---@field lines string[]
---@field hl Highlight[]
---@field lineNr number
---@field current string
local Text = {}
Text.__index = Text

function Text.len(str) return vim.fn.strdisplaywidth(str) end

function Text:new()
  local this = { lines = {}, hl = {}, lineNr = 0, current = "" }
  setmetatable(this, self)
  return this
end

function Text:nl()
  local line = self.current:gsub("[\n]", " ")
  table.insert(self.lines, line)
  self.current = ""
  self.lineNr = self.lineNr + 1
end

function Text:render(str, group, opts)
  if type(opts) == "string" then opts = { append = opts } end
  opts = opts or {}

  if group then
    if opts.exact ~= true then group = "WhichKey" .. group end
    local from = string.len(self.current)
    ---@class Highlight
    local hl
    hl = { line = self.lineNr, from = from, to = from + string.len(str), group = group }
    table.insert(self.hl, hl)
  end
  self.current = self.current .. str
  if opts.append then self.current = self.current .. opts.append end
  if opts.nl then self:nl() end
end

function Text:set(row, col, str, group)
  str = str:gsub("[\n]", " ")

  for i,v in ipairs(config.options.hidden) do 
    str = str:gsub(v, "")
  end

  -- extend lines if needed
  for i = 1, row, 1 do if not self.lines[i] then self.lines[i] = "" end end

  -- extend columns when needed
  if #self.lines[row] < col then
    self.lines[row] = self.lines[row] .. string.rep(" ", col - #self.lines[row])
  end

  self.lines[row] = self.lines[row]:sub(0, col) .. str .. self.lines[row]:sub(col + Text.len(str))

  if not group then return end
  -- set highlights
  table.insert(self.hl, {
    line = row - 1,
    from = col,
    to = col + string.len(str),
    group = "WhichKey" .. group,
  })
  self:highlight(row - 1, col, col + string.len(str), "WhichKey" .. group)
end

function Text:highlight(line, from, to, group)
  table.insert(self.hl, { line = line, from = from, to = to, group = group })
end

return Text
