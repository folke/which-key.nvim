local M = {}

M.name = "registers"

M.actions = {
  { trigger = "\"", mode = "n" },
  { trigger = "@", mode = "n" },
  { trigger = "<c-r>", mode = "i" },
}

local registers = "*+\"-:.%/#=_abcdefghijklmnopqrstuvwxyz0123456789"

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
function M.run(trigger, mode, buf)
  local items = {}

  for i = 1, #registers, 1 do
    local key = registers:sub(i, i)
    local value = vim.fn.getreg(key)

    if value ~= "" then
      table.insert(items, { key = key, label = labels[key] or "", value = value })
    end
  end
  return items
end

return M
