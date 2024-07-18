local Util = require("which-key.util")

---@diagnostic disable: missing-fields, inject-field
---@type wk.Plugin
local M = {}

M.name = "registers"

M.mappings = {
  icon = { icon = "󰅍 ", color = "blue" },
  plugin = "registers",
  { '"', mode = { "n", "x" }, desc = "registers" },
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
  local has_clipboard = vim.g.loaded_clipboard_provider == 2

  for i = 1, #M.registers, 1 do
    local key = M.registers:sub(i, i)
    local value = ""
    if is_osc52 and key:match("[%+%*]") then
      value = "OSC 52 detected, register not checked to maintain compatibility"
    elseif has_clipboard or not key:match("[%+%*]") then
      local ok, reg_value = pcall(vim.fn.getreg, key, 1)
      value = (ok and reg_value or "") --[[@as string]]
    end
    if value ~= "" then
      value = vim.fn.keytrans(value) --[[@as string]]
      for k, v in pairs(M.replace) do
        value = value:gsub(k, v) --[[@as string]]
      end
      table.insert(items, { key = key, desc = labels[key] or "", value = value })
    end
  end
  return items
end

return M
