local M = {}

M.name = "presets"

M.operators = {
  preset = true,
  mode = { "n", "x" },
  { "!", desc = "Run program" },
  { "<", desc = "Indent left" },
  { ">", desc = "Indent right" },
  { "V", desc = "Visual Line" },
  { "c", desc = "Change" },
  { "d", desc = "Delete" },
  { "gU", desc = "Uppercase" },
  { "gu", desc = "Lowercase" },
  { "g~", desc = "Toggle case" },
  { "gw", desc = "Format" },
  { "r", desc = "Replace" },
  { "v", desc = "Visual" },
  { "y", desc = "Yank" },
  { "zf", desc = "Create fold" },
  { "~", desc = "Toggle case" },
}

M.motions = {
  mode = { "o", "x", "n" },
  preset = true,
  { "$", desc = "End of line" },
  { "%", desc = "Matching (){}[]" },
  { "0", desc = "Start of line" },
  { "F", desc = "Move to prev char" },
  { "G", desc = "Last line" },
  { "T", desc = "Move before prev char" },
  { "^", desc = "Start of line (non ws)" },
  { "b", desc = "Prev word" },
  { "e", desc = "Next end of word" },
  { "f", desc = "Move to next char" },
  { "ge", desc = "Prev end of word" },
  { "gg", desc = "First line" },
  { "h", desc = "Left" },
  { "j", desc = "Down" },
  { "k", desc = "Up" },
  { "l", desc = "Right" },
  { "t", desc = "Move before next char" },
  { "w", desc = "Next word" },
  { "{", desc = "Prev empty line" },
  { "}", desc = "Next empty line" },
  { ";", desc = "Next ftFT" },
  { ",", desc = "Prev ftFT" },
  { "/", desc = "Search forward" },
  { "?", desc = "Search backward" },
  { "B", desc = "Prev WORD" },
  { "E", desc = "Next end of WORD" },
  { "W", desc = "Next WORD" },
}

M.text_objects = {
  mode = { "o", "x" },
  preset = true,
  { "a", group = "around" },
  { 'a"', desc = '" string' },
  { "a'", desc = "' string" },
  { "a(", desc = "[(]) block" },
  { "a)", desc = "[(]) block" },
  { "a<", desc = "<> block" },
  { "a>", desc = "<> block" },
  { "aB", desc = "[{]} block" },
  { "aW", desc = "WORD with ws" },
  { "a[", desc = "[] block" },
  { "a]", desc = "[] block" },
  { "a`", desc = "` string" },
  { "ab", desc = "[(]) block" },
  { "ap", desc = "paragraph" },
  { "as", desc = "sentence" },
  { "at", desc = "tag block" },
  { "aw", desc = "word with ws" },
  { "a{", desc = "[{]} block" },
  { "a}", desc = "[{]} block" },
  { "i", group = "inside" },
  { 'i"', desc = 'inner " string' },
  { "i'", desc = "inner ' string" },
  { "i(", desc = "inner [(])" },
  { "i)", desc = "inner [(])" },
  { "i<", desc = "inner <>" },
  { "i>", desc = "inner <>" },
  { "iB", desc = "inner [{]}" },
  { "iW", desc = "inner WORD" },
  { "i[", desc = "inner []" },
  { "i]", desc = "inner []" },
  { "i`", desc = "inner ` string" },
  { "ib", desc = "inner [(])" },
  { "ip", desc = "inner paragraph" },
  { "is", desc = "inner sentence" },
  { "it", desc = "inner tag block" },
  { "iw", desc = "inner word" },
  { "i{", desc = "inner [{]}" },
  { "i}", desc = "inner [{]}" },
}

M.windows = {
  preset = true,
  mode = { "n", "x" },
  { "<c-w>", group = "window" },
  { "<c-w>+", desc = "Increase height" },
  { "<c-w>-", desc = "Decrease height" },
  { "<c-w><", desc = "Decrease width" },
  { "<c-w>=", desc = "Equally high and wide" },
  { "<c-w>>", desc = "Increase width" },
  { "<c-w>T", desc = "Break out into a new tab" },
  { "<c-w>_", desc = "Max out the height" },
  { "<c-w>h", desc = "Go to the left window" },
  { "<c-w>j", desc = "Go to the down window" },
  { "<c-w>k", desc = "Go to the up window" },
  { "<c-w>l", desc = "Go to the right window" },
  { "<c-w>o", desc = "Close all other windows" },
  { "<c-w>q", desc = "Quit a window" },
  { "<c-w>s", desc = "Split window" },
  { "<c-w>v", desc = "Split window vertically" },
  { "<c-w>w", desc = "Switch windows" },
  { "<c-w>x", desc = "Swap current with next" },
  { "<c-w>|", desc = "Max out the width" },
  { "<c-w>H", desc = "Move window to far left" },
  { "<c-w>J", desc = "Move window to far bottom" },
  { "<c-w>K", desc = "Move window to far top" },
  { "<c-w>L", desc = "Move window to far right" },
}

M.z = {
  preset = true,
  { "z<CR>", desc = "Top this line" },
  { "z=", desc = "Spelling suggestions" },
  { "zA", desc = "Toggle all folds under cursor" },
  { "zC", desc = "Close all folds under cursor" },
  { "zD", desc = "Delete all folds under cursor" },
  { "zE", desc = "Delete all folds in file" },
  { "zH", desc = "Half screen to the left" },
  { "zL", desc = "Half screen to the right" },
  { "zM", desc = "Close all folds" },
  { "zO", desc = "Open all folds under cursor" },
  { "zR", desc = "Open all folds" },
  { "za", desc = "Toggle fold under cursor" },
  { "zb", desc = "Bottom this line" },
  { "zc", desc = "Close fold under cursor" },
  { "zd", desc = "Delete fold under cursor" },
  { "ze", desc = "Right this line" },
  { "zg", desc = "Add word to spell list" },
  { "zi", desc = "Toggle folding" },
  { "zm", desc = "Fold more" },
  { "zo", desc = "Open fold under cursor" },
  { "zr", desc = "Fold less" },
  { "zs", desc = "Left this line" },
  { "zt", desc = "Top this line" },
  { "zv", desc = "Show cursor line" },
  { "zw", desc = "Mark word as bad/misspelling" },
  { "zx", desc = "Update folds" },
  { "zz", desc = "Center this line" },
}

M.nav = {
  preset = true,
  { "H", desc = "Home line of window (top)" },
  { "L", desc = "Last line of window" },
  { "M", desc = "Middle line of window" },
  { "[%", desc = "Previous unmatched group" },
  { "[(", desc = "Previous (" },
  { "[<", desc = "Previous <" },
  { "[M", desc = "Previous method end" },
  { "[m", desc = "Previous method start" },
  { "[s", desc = "Previous misspelled word" },
  { "[{", desc = "Previous {" },
  { "]%", desc = "Next unmatched group" },
  { "](", desc = "Next (" },
  { "]<", desc = "Next <" },
  { "]M", desc = "Next method end" },
  { "]m", desc = "Next method start" },
  { "]s", desc = "Next misspelled word" },
  { "]{", desc = "Next {" },
}

M.g = {
  preset = true,
  { "g%", desc = "Cycle backwards through results" },
  { "g,", desc = "Go to [count] newer position in change list" },
  { "g;", desc = "Go to [count] older position in change list" },
  { "gN", desc = "Search backwards and select" },
  { "gT", desc = "Go to previous tab page" },
  { "gf", desc = "Go to file under cursor" },
  { "gi", desc = "Go to last insert" },
  { "gn", desc = "Search forwards and select" },
  { "gt", desc = "Go to next tab page" },
  { "gv", desc = "Last visual selection" },
  { "gx", desc = "Open file with system app" },
}

function M.setup(opts)
  local wk = require("which-key")

  -- Operators
  if opts.operators then
    wk.add(M.operators)
  end

  -- Motions
  if opts.motions then
    wk.add(M.motions)
  end

  -- Text objects
  if opts.text_objects then
    wk.add(M.text_objects)
  end

  -- Misc
  for _, preset in pairs({ "windows", "nav", "z", "g" }) do
    if opts[preset] ~= false then
      wk.add(M[preset])
    end
  end
end

return M
