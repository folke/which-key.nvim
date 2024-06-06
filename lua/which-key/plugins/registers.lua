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

function M.setup(_wk, _config, options) end

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

-- This function makes the assumption that OSC 52 is set up per :help osc-52
M.osc52_active = function()
  -- If no clipboard set, can't be OSC 52
  if not vim.g.clipboard then
    return false
  end

  -- Per the docs, OSC 52 should be set up with a name field in the table
  if vim.g.clipboard.name == "OSC 52" then
    return true
  end

  return false
end

---@type Plugin
---@return PluginItem[]
function M.run(_trigger, _mode, _buf)
  local items = {}

  local osc52_skip_keys = { "+", "*" }

  for i = 1, #M.registers, 1 do
    local key = M.registers:sub(i, i)

    local value = ""

    if M.osc52_active() and vim.tbl_contains(osc52_skip_keys, key) then
      value = "OSC 52 detected, register not checked to maintain compatibility"
    else
      local ok, reg_value = pcall(vim.fn.getreg, key, 1)
      if ok then
        value = reg_value
      end
    end

    if value ~= "" then
      table.insert(items, { key = key, desc = labels[key] or "", value = value })
    end
  end
  return items
end

return M
