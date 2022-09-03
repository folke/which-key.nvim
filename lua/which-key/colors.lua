local M = {}

local links = {
  [""] = "Function",
  Separator = "DiffAdd",
  Group = "Keyword",
  Desc = "Identifier",
  Float = "NormalFloat",
  Value = "Comment",
}

function M.setup()
  for k, v in pairs({
    [""] = "Function",
    Separator = "DiffAdd",
    Group = "Keyword",
    Desc = "Identifier",
    Float = "NormalFloat",
    Value = "Comment",
  }) do
    vim.api.nvim_set_hl(0, 'WhichKey'..k, {link = v, default = true})
  end
end

return M
