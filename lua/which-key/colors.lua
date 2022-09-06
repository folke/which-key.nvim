local M = {}

local links = {
  [""] = "Function",
  Separator = "Comment",
  Group = "Keyword",
  Desc = "Identifier",
  Float = "NormalFloat",
  Border = "FloatBorder",
  Value = "Comment",
}

function M.setup()
  for k, v in pairs(links) do
    vim.api.nvim_set_hl(0, "WhichKey" .. k, { link = v, default = true })
  end
end

return M
