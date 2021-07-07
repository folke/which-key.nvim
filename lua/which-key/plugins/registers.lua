local extra = require("which-key.config").options.plugins.presets.extra

local M = {}

M.name = "registers"

M.actions = {
  { trigger = '"', mode = "n" },
  { trigger = "@", mode = "n" },
  { trigger = "<c-r>", mode = "i" },
  { trigger = "<c-r>", mode = "c" },
}

if extra == true then
  M.actions = {
    { trigger = '"', mode = "n", label = "λ_use λ for next delete, yank or put" },
    { trigger = "@", mode = "n", label = "α,Ψ_execute the contents of register α N times" },
    { trigger = "<c-r>", mode = "i", label = "λ_insert a register's content" },
    {
      trigger = "<c-r>",
      mode = "c",
      label = "λ_insert a register's content or Δobject as if typed",
    },
  }
end

local insert_mapping = {
  ["<C-r><C-r>"] = "λ_insert a register's content literally",
  ["<C-r><C-o>"] = 'λ_like "<C-r><C-r>", but don\'t auto-indent',
  ["<C-r><C-p>"] = 'λ_like "<C-r><C-r>", but fix indent',
}

local command_same_as = {
  ["<C-r><C-r>"] = { "<C-r><C-o>" },
}

local command_mapping = {
  ["<C-r><C-r>"] = "λ_insert a register's content or Δobject literally",
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

---@type Plugin
---@return PluginItem[]
function M.run(_trigger, _mode, _buf)
  local items = {}

  for i = 1, #M.registers, 1 do
    local key = M.registers:sub(i, i)
    local ok, value = pcall(vim.fn.getreg, key, 1)
    if not ok then
      value = ""
    end

    if value ~= "" then
      table.insert(items, { key = key, label = labels[key] or "", value = value })
    end
  end
  return items
end

return M
