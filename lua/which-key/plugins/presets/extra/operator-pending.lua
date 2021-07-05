local wk = require("which-key")

local operator_pending_binds = {
  ["v"] = "force operator to work charwise",
  ["V"] = "force operator to work linewise",
  ["<C-v>"] = "force operator to work blockwise",
}

wk.register(operator_pending_binds, { mode = "o", preset = true })
