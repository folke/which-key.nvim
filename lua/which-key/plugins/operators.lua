local M = {}

M.name = "operators"

M.operators = {
  d = "Delete",
  c = "Change",
  y = "Yank (copy)",
  ["g~"] = "Toggle case",
  ["gu"] = "Lowercase",
  ["gU"] = "Uppercase",
  [">"] = "Indent right",
  ["<lt>"] = "Indent left",
  ["zf"] = "Create fold",
  ["!"] = "Filter though external program",
  ["v"] = "Start visual mode",

}

function M.setup(wk) wk.register(M.operators, { mode = "n", prefix = "" }) end

return M
