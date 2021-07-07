local extra = require("which-key.config").options.plugins.presets.extra

local M = {}

M.name = "marks"

M.actions = {
  { trigger = "'", mode = "n" },
  { trigger = "`", mode = "n" },
  { trigger = "g`", mode = "n" },
  { trigger = "g'", mode = "n" },
}

if extra == true then
  M.actions = {
    { trigger = "'", mode = "n", label = "μ,Ξ_Δ to the first CHAR on the line with mark μ" },
    { trigger = "`", mode = "n", label = "μ,Ξ_Δ to the mark μ" },
    { trigger = "g`", mode = "n", label = "μ,Ξ_like |'| but without changing the jumplist" },
    { trigger = "g'", mode = "n", label = "μ,Ξ_like |`| but without changing the jumplist" },
  }
end

local normal_mapping = {
  ["''"] = "Ξ_Δ to the first CHAR of the line where Δ was before the latest jump.",
  ["'("] = "Ξ_Δ to the first CHAR on the line of the start of the current sentence",
  ["')"] = "Ξ_Δ to the first CHAR on the line of the end of the current sentence",
  ["'<LT>"] = "Ξ_Δ to the first CHAR of the line where highlighted area starts/started in the current buffer.",
  ["'>"] = "Ξ_Δ to the first CHAR of the line where highlighted area ends/ended in the current buffer.",
  ["'["] = "Ξ_Δ to the first CHAR on the line of the start of last operated text or start of put text",
  ["']"] = "Ξ_Δ to the first CHAR on the line of the end of last operated text or end of put text",
  ["'{"] = "Ξ_Δ to the first CHAR on the line of the start of the current paragraph",
  ["'}"] = "Ξ_Δ to the first CHAR on the line of the end of the current paragraph",
  ["`("] = "Ξ_Δ to the start of the current sentence",
  ["`)"] = "Ξ_Δ to the end of the current sentence",
  ["`<LT>"] = "Ξ_Δ to the start of the highlighted area",
  ["`>"] = "Ξ_Δ to the end of the highlighted area",
  ["`["] = "Ξ_Δ to the start of last operated text or start of putted text",
  ["`]"] = "Ξ_Δ to the end of last operated text or end of putted text",
  ["``"] = "Ξ_Δ to the position before latest jump",
  ["`{"] = "Ξ_Δ to the start of the current paragraph",
  ["`}"] = "Ξ_Δ to the end of the current paragraph",
}

local labels = {
  ["^"] = "Last position of cursor in insert mode",
  ["."] = "Last change in current buffer",
  ['"'] = "Last exited current buffer",
  ["0"] = "In last file edited",
  ["'"] = "Back to line in current buffer where jumped from",
  ["`"] = "Back to position in current buffer where jumped from",
  ["["] = "To beginning of previously changed or yanked text",
  ["]"] = "To end of previously changed or yanked text",
  ["<lt>"] = "To beginning of last visual selection",
  [">"] = "To end of last visual selection",
}

---@type Plugin
---@return PluginItem[]
function M.run(_trigger, _mode, buf)
  local items = {}

  local marks = {}
  for _, mark in pairs(vim.fn.getmarklist(buf)) do
    table.insert(marks, mark)
  end
  for _, mark in pairs(vim.fn.getmarklist()) do
    table.insert(marks, mark)
  end

  for _, mark in pairs(marks) do
    local key = mark.mark:sub(2, 2)
    if key == "<" then
      key = "<lt>"
    end
    local lnum = mark.pos[2]

    local line
    if mark.pos[1] and mark.pos[1] ~= 0 then
      local lines = vim.fn.getbufline(mark.pos[1], lnum)
      if lines and lines[1] then
        line = lines[1]
      end
    end

    local file = mark.file and vim.fn.fnamemodify(mark.file, ":p:.")

    local value = string.format("%4d  ", lnum)

    table.insert(items, {
      key = key,
      label = labels[key] or "",
      value = value .. (line or file or ""),
      highlights = { { 1, #value - 1, "Number" } },
    })
  end
  return items
end

return M
