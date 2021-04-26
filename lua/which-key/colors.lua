local M = {}

local links = {
  [""] = "Function",
  Seperator = "DiffAdded",
  Group = "Keyword",
  Desc = "Identifier",
  WhichKeyFloating = "NormalFloat",
}

function M.setup()
  for k, v in pairs(links) do vim.api.nvim_command("hi def link WhichKey" .. k .. " " .. v) end
end

return M
