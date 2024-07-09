---@diagnostic disable: missing-fields, inject-field
---@type Plugin
local M = {}

M.name = "registers"

M.actions = {
  { trigger = '"', mode = "n" },
  { trigger = '"', mode = "v" },
  -- { trigger = "@", mode = "n" },
  { trigger = "<c-r>", mode = "i" },
  { trigger = "<c-r>", mode = "c" },
}

M.registers = '*+"-:.%/#=_abcdefghijklmnopqrstuvwxyz0123456789'

local labels = {
  ['"'] = "last deleted, changed, or yanked content",
  ["0"] = "last yank",
  ["-"] = "deleted or changed content smaller than one line",
  ["."] = "last inserted text",
  ["%"] = "name of the current file",
  [":"] = "most recent executed command",
  ["#"] = "alternate buffer",
  ["="] = "result of an expression",
  ["+"] = "synchronized with the system clipboard",
  ["*"] = "synchronized with the selection clipboard",
  ["_"] = "black hole",
  ["/"] = "last search pattern",
}

function M.expand()
  local items = {} ---@type PluginItem[]

  local is_osc52 = vim.g.clipboard and vim.g.clipboard.name == "OSC 52"

  for i = 1, #M.registers, 1 do
    local key = M.registers:sub(i, i)
    local value = ""
    if is_osc52 and vim.tbl_contains({ "+", "*" }, key) then
      value = "OSC 52 detected, register not checked to maintain compatibility"
    else
      local ok, reg_value = pcall(vim.fn.getreg, key, 1)
      value = ok and reg_value or ""
    end
    if value ~= "" then
      table.insert(items, { key = key, desc = labels[key] or "", value = value })
    end
  end
  return items
end

return M
