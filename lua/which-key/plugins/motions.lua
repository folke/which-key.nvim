local M = {}

M.name = "motions"

local motions = {
  ["h"] = "Left",
  ["j"] = "Down",
  ["k"] = "Up",
  ["l"] = "Right",
  ["w"] = "Next word",
  ["%"] = "Matching character: '()', '{}', '[]'",
  ["b"] = "Previous word",
  ["e"] = "Next end of word",
  ["ge"] = "Previous end of word",
  ["0"] = "Start of line",
  ["^"] = "Start of line (non-blank)",
  ["$"] = "End of line",
  ["f"] = "Move to next char",
  ["F"] = "Move to previous char",
  ["t"] = "Move before next char",
  ["T"] = "Move before previous char",
  ["gg"] = "First line",
  ["G"] = "Last line",
  ["{"] = "Previous empty line",
  ["}"] = "Next empty line",
}

function M.setup(wk)

  local ops = require("which-key.plugins.operators")
  for op, _ in pairs(ops.operators) do wk.register(motions, { mode = "n", prefix = op }) end

  wk.register(motions, { mode = "v", prefix = "" })
  wk.register(motions, { mode = "n", prefix = "" })
end

return M
