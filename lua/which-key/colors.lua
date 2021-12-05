local M = {}

local links = {
  [""] = "Function",
  Separator = "DiffAdded",
  Group = "Keyword",
  Desc = "Identifier",
  Float = "NormalFloat",
  Value = "Comment",
}

if vim.fn.hlexists("WhichKeySeparator") then
  links["Separator"] = "WhichKeySeparator"
end

function M.setup()
  for k, v in pairs(links) do
    vim.api.nvim_command("hi def link WhichKey" .. k .. " " .. v)
  end
end

return M
