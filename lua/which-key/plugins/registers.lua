local M = {}

M.name = "registers"

M.actions = {
  { trigger = "\"", mode = "n" },
  { trigger = "@", mode = "n" },
  { trigger = "<c-r>", mode = "i" },
  { trigger = "<c-r>", mode = "c" },
}
--[[

  n
  
  ["\""] = "λ use λ for next delete, yank or put ({.%#:} only work with put)",
  
  ["@"] = "α_Ψ execute the contents of register α N times", -- TODO

  i

  ["<C-r>"] = "λ insert a register's content"
  ["<C-r><C-r>"] = "λ insert a register's content literally",
  ["<C-r><C-o>"] = "λ like \"<C-r><C-r>\", but don't auto-indent",
  ["<C-r><C-p>"] = "λ like \"<C-r><C-r>\", but fix indent",

  c

  ["<C-r>"] = "λ insert a register's content or Δobject as if typed",
  ["<C-r><C-r>"] = "λ insert a register's content or Δobject literally",


  same_as 
  ["<C-r><C-r>"] = { "<C-r><C-o>"}
--]]

M.registers = "*+\"-:.%/#=_abcdefghijklmnopqrstuvwxyz0123456789"

local labels = {
  ["\""] = "last deleted, changed, or yanked content",
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

---@type Plugin
---@return PluginItem[]
function M.run(_trigger, _mode, _buf)
  local items = {}

  for i = 1, #M.registers, 1 do
    local key = M.registers:sub(i, i)
    local ok, value = pcall(vim.fn.getreg, key, 1)
    if not ok then value = "" end

    if value ~= "" then
      table.insert(items, { key = key, label = labels[key] or "", value = value })
    end
  end
  return items
end

return M
