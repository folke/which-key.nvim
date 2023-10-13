local M = {}

M.name = "misc"

local misc = {
  windows = {
    ["<c-w>"] = {
      name = "window",
      s = "Split window",
      v = "Split window vertically",
      w = "Switch windows",
      q = "Quit a window",
      o = "Close all other windows",
      T = "Break out into a new tab",
      x = "Swap current with next",
      ["-"] = "Decrease height",
      ["+"] = "Increase height",
      ["<lt>"] = "Decrease width",
      [">"] = "Increase width",
      ["|"] = "Max out the width",
      ["_"] = "Max out the height",
      ["="] = "Equally high and wide",
      h = "Go to the left window",
      l = "Go to the right window",
      k = "Go to the up window",
      j = "Go to the down window",
    },
  },
  z = {
    ["z"] = {
      o = "Open fold under cursor",
      O = "Open all folds under cursor",
      c = "Close fold under cursor",
      C = "Close all folds under cursor",
      a = "Toggle fold under cursor",
      A = "Toggle all folds under cursor",
      v = "Show cursor line",
      M = "Close all folds",
      R = "Open all folds",
      m = "Fold more",
      r = "Fold less",
      x = "Update folds",
      z = "Center this line",
      t = "Top this line",
      ["<CR>"] = "Top this line, 1st non-blank col",
      b = "Bottom this line",
      g = "Add word to spell list",
      w = "Mark word as bad/misspelling",
      e = "Right this line",
      s = "Left this line",
      H = "Half screen to the left",
      L = "Half screen to the right",
      i = "Toggle folding",
      ["="] = "Spelling suggestions",
    },
  },
  nav = {
    ["[{"] = "Previous {",
    ["[("] = "Previous (",
    ["[<lt>"] = "Previous <",
    ["[m"] = "Previous method start",
    ["[M"] = "Previous method end",
    ["[%"] = "Previous unmatched group",
    ["[s"] = "Previous misspelled word",
    ["]{"] = "Next {",
    ["]("] = "Next (",
    ["]<lt>"] = "Next <",
    ["]m"] = "Next method start",
    ["]M"] = "Next method end",
    ["]%"] = "Next unmatched group",
    ["]s"] = "Next misspelled word",
    ["H"] = "Home line of window (top)",
    ["M"] = "Middle line of window",
    ["L"] = "Last line of window",
  },
  g = {
    ["gf"] = "Go to file under cursor",
    ["gx"] = "Open the file under cursor with system app",
    ["gi"] = "Move to the last insertion and INSERT",
    ["gv"] = "Switch to VISUAL using last selection",
    ["gn"] = "Search forwards and select",
    ["gN"] = "Search backwards and select",
    ["g%"] = "Cycle backwards through results",
    ["gt"] = "Go to next tab page",
    ["gT"] = "Go to previous tab page",
  },
}

function M.setup(wk, config)
  for key, mappings in pairs(misc) do
    if config[key] ~= false then
      wk.register(mappings, { mode = "n", prefix = "", preset = true })
    end
  end
end

return M
