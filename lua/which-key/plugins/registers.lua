---@diagnostic disable: missing-fields, inject-field
---@type wk.Plugin
local M = {}

M.name = "registers"

M.mappings = {
  icon = { icon = "󰅍 ", color = "blue" },
  plugin = "registers",
  { '"', mode = { "n", "v" }, desc = "registers" },
  { "<c-r>", mode = { "i", "c" }, desc = "registers" },
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

M.replace = {
  ["<Space>"] = " ",
  ["<lt>"] = "<",
  ["<NL>"] = "\n",
  ["\r"] = "",
}

function M.expand()
  local items = {} ---@type wk.Plugin.item[]

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
      value = vim.fn.keytrans(value)
      for k, v in pairs(M.replace) do
        value = value:gsub(k, v)
      end
      table.insert(items, { key = key, desc = labels[key] or "", value = value })
    end
  end
  return items
end

return M
