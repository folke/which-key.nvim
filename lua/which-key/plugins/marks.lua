local M = {}

M.name = "marks"

M.triggers = { { trigger = "`", mode = "n" }, { trigger = "'", mode = "n" } }

local labels = {
  ["^"] = "Last position of cursor in insert mode",
  ["."] = "Last change in current buffer",
  ["\""] = "Last exited current buffer",
  ["0"] = "In last file edited",
  ["'"] = "Back to line in current buffer where jumped from",
  ["`"] = "Back to position in current buffer where jumped from",
  ["["] = "To beginning of previously changed or yanked text",
  ["]"] = "To end of previously changed or yanked text",
  ["<"] = "To beginning of last visual selection",
  [">"] = "To end of last visual selection",
}

---@type Plugin
---@return PluginItem[]
function M.handler(_trigger, _mode, buf)
  local items = {}

  local marks = {}
  for _, mark in pairs(vim.fn.getmarklist(buf)) do table.insert(marks, mark) end
  for _, mark in pairs(vim.fn.getmarklist()) do table.insert(marks, mark) end

  -- table.sort(marks, function(a, b) return a.mark < b.mark end)

  for _, mark in pairs(marks) do
    local key = mark.mark:sub(2, 2)
    local line = mark.pos[2]

    local value = ""

    local mbuf = mark.pos[1]
    if mbuf and mbuf ~= 0 then
      local lines = vim.fn.getbufline(mbuf, line)
      if lines and lines[1] then value = lines[1] end
    end
    if value == "" and mark.file then value = vim.fn.fnamemodify(mark.file, ":p:.") end

    local line_str = string.format("%3d  ", line)
    value = line_str .. value

    local label = labels[key] or ""
    table.insert(items, {
      key = key,
      label = label,
      value = value,
      highlights = { { 1, #line_str - 1, "Number" } },
    })
  end
  return items
end

return M

