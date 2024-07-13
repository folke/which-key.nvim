local M = {}

M.colors = {
  [""] = "Function", -- the key
  Separator = "Comment", -- the separator between the key and its description
  Group = "Keyword", -- group name
  Desc = "Identifier", -- description
  Normal = "NormalFloat", -- Normal in th which-key window
  Title = "FloatTitle", -- Title of the which-key window
  Border = "FloatBorder", -- Border of the which-key window
  Value = "Comment", -- values by plugins (like marks, registers, etc)
  Icon = "@markup.link", -- icons
  IconAzure = "Function",
  IconBlue = "DiagnosticInfo",
  IconCyan = "DiagnosticHint",
  IconGreen = "DiagnosticOk",
  IconGrey = "Normal",
  IconOrange = "DiagnosticWarn",
  IconPurple = "Constant",
  IconRed = "DiagnosticError",
  IconYellow = "DiagnosticWarn",
}

function M.setup()
  for k, v in pairs(M.colors) do
    vim.api.nvim_set_hl(0, "WhichKey" .. k, { link = v, default = true })
  end
  M.fix_colors()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("wk-colors", { clear = true }),
    callback = M.fix_colors,
  })
end

function M.fix_colors()
  for k in pairs(M.colors) do
    if k:find("^Icon") then
      local color = k:gsub("^Icon", "")
      local wk_hl_group = "WhichKeyIcon" .. color
      local mini_hl_group = "MiniIcons" .. color
      local wk_hl = vim.api.nvim_get_hl(0, {
        name = wk_hl_group,
        link = true,
      })
      local mini_hl = vim.api.nvim_get_hl(0, {
        name = mini_hl_group,
        link = true,
      })
      if wk_hl.default and not vim.tbl_isempty(mini_hl) then
        vim.api.nvim_set_hl(0, wk_hl_group, { link = mini_hl_group })
      end
    end
  end
end

return M
