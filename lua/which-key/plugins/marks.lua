---@diagnostic disable: missing-fields, inject-field
---@type Plugin
local M = {}

M.name = "marks"

M.actions = {
  { trigger = "`", mode = "n" },
  { trigger = "'", mode = "n" },
  { trigger = "g`", mode = "n" },
  { trigger = "g'", mode = "n" },
}

local labels = {
  ["^"] = "Last position of cursor in insert mode",
  ["."] = "Last change in current buffer",
  ['"'] = "Last exited current buffer",
  ["0"] = "In last file edited",
  ["'"] = "Back to line in current buffer where jumped from",
  ["`"] = "Back to position in current buffer where jumped from",
  ["["] = "To beginning of previously changed or yanked text",
  ["]"] = "To end of previously changed or yanked text",
  ["<lt>"] = "To beginning of last visual selection",
  [">"] = "To end of last visual selection",
}

function M.expand()
  local buf = vim.api.nvim_get_current_buf()
  local items = {} ---@type PluginItem[]

  local marks = {} ---@type vim.fn.getmarklist.ret.item[]
  vim.list_extend(marks, vim.fn.getmarklist(buf))
  vim.list_extend(marks, vim.fn.getmarklist())

  for _, mark in pairs(marks) do
    local key = mark.mark:sub(2, 2)
    local lnum = mark.pos[2]

    local line ---@type string?
    if mark.pos[1] and mark.pos[1] ~= 0 then
      line = vim.fn.getbufline(mark.pos[1], lnum)[1] --[[@as string?]]
    end

    local file = mark.file and vim.fn.fnamemodify(mark.file, ":p:~:.")

    local value = string.format("%4d  ", lnum)
    value = value .. (line or file or "")

    table.insert(items, {
      key = key,
      desc = labels[key] or file and ("file: " .. file) or "",
      value = value,
      highlights = { { 1, 5, "Number" } },
    })
  end

  return items
end

return M
