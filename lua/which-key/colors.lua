local M = {}

M.colors = {
  [""] = "Function", -- the key
  Separator = "Comment", -- the separator between the key and its description
  Group = "Keyword", -- group name
  Desc = "Identifier", -- description
  Float = "NormalFloat", -- Normal in th which-key window
  Title = "FloatTitle", -- Title of the which-key window
  Border = "FloatBorder", -- Border of the which-key window
  Value = "Comment", -- values by plugins (like marks, registers, etc)
}

function M.setup()
  for k, v in pairs(M.colors) do
    vim.api.nvim_set_hl(0, "WhichKey" .. k, { link = v, default = true })
  end
end

return M
