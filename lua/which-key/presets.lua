---@type table<string, wk.Opts>
return {
  helix = {
    win = {
      width = { min = 30, max = 60 },
      height = { min = 4, max = 0.5 },
      col = 1,
      border = "rounded",
      title = true,
      title_pos = "left",
    },
  },
  modern = {
    win = {
      width = 0.9,
      height = { min = 4, max = 0.25 },
      col = 0.05,
      border = "rounded",
      title = true,
      title_pos = "center",
    },
  },
  classic = {
    win = {
      width = 1,
      height = { min = 4, max = 25 },
      col = 0,
      border = "none",
    },
  },
}
