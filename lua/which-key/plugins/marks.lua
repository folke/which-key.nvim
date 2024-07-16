---@diagnostic disable: missing-fields, inject-field
---@type wk.Plugin
local M = {}

M.name = "marks"

M.mappings = {
  icon = { icon = "󰸕 ", color = "orange" },
  plugin = "marks",
  { "`", desc = "marks" },
  { "'", desc = "marks" },
  { "g`", desc = "marks" },
  { "g'", desc = "marks" },
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

M.cols = {
  { key = "lnum", hl = "Number", align = "right" },
}

function M.expand()
  local buf = vim.api.nvim_get_current_buf()
  local items = {} ---@type wk.Plugin.item[]

  local marks = {} ---@type vim.fn.getmarklist.ret.item[]
  vim.list_extend(marks, vim.fn.getmarklist(buf))
  vim.list_extend(marks, vim.fn.getmarklist())

  for _, mark in pairs(marks) do
    local key = mark.mark:sub(2, 2)
    local lnum = mark.pos[2]

    local line ---@type string?
    if mark.pos[1] and mark.pos[1] ~= 0 then
      line = vim.api.nvim_buf_get_lines(mark.pos[1], lnum - 1, lnum, false)[1]
    end

    local file = mark.file and vim.fn.fnamemodify(mark.file, ":p:~:.")

    table.insert(items, {
      key = key,
      desc = labels[key] or file and ("file: " .. file) or "",
      value = vim.trim(line or file or ""),
      highlights = { { 1, 5, "Number" } },
      lnum = lnum,
    })
  end

  return items
end

return M
