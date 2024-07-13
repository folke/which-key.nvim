local M = {}

M.name = "presets"

M.operators = {
  preset = true,
  mode = { "n", "x" },
  { "!", desc = "Filter through external program" },
  { "<", desc = "Indent left" },
  { ">", desc = "Indent right" },
  { "V", desc = "Visual Line" },
  { "c", desc = "Change" },
  { "d", desc = "Delete" },
  { "gU", desc = "Uppercase" },
  { "gu", desc = "Lowercase" },
  { "g~", desc = "Toggle case" },
  { "r", desc = "Replace" },
  { "v", desc = "Visual" },
  { "y", desc = "Yank" },
  { "zf", desc = "Create fold" },
  { "~", desc = "Toggle case" },
}

M.motions = {
  mode = { "o", "x" },
  preset = true,
  { "$", desc = "End of line" },
  { "%", desc = "Matching character: '()', '{}', '[]'" },
  { "0", desc = "Start of line" },
  { "F", desc = "Move to previous char" },
  { "G", desc = "Last line" },
  { "T", desc = "Move before previous char" },
  { "^", desc = "Start of line (non-blank)" },
  { "b", desc = "Previous word" },
  { "e", desc = "Next end of word" },
  { "f", desc = "Move to next char" },
  { "ge", desc = "Previous end of word" },
  { "gg", desc = "First line" },
  { "h", desc = "Left" },
  { "j", desc = "Down" },
  { "k", desc = "Up" },
  { "l", desc = "Right" },
  { "t", desc = "Move before next char" },
  { "w", desc = "Next word" },
  { "{", desc = "Previous empty line" },
  { "}", desc = "Next empty line" },
}

M.text_objects = {
  mode = { "o", "x" },
  preset = true,
  { "a", group = "around" },
  { 'a"', desc = "double quoted string" },
  { "a'", desc = "single quoted string" },
  { "a(", desc = "same as ab" },
  { "a)", desc = "same as ab" },
  { "a<", desc = "a <> from '<' to the matching '>'" },
  { "a>", desc = "same as a<" },
  { "aB", desc = "a Block from [{ to ]} (with brackets)" },
  { "aW", desc = "a WORD (with white space)" },
  { "a[", desc = "a [] from '[' to the matching ']'" },
  { "a]", desc = "same as a[" },
  { "a`", desc = "string in backticks" },
  { "ab", desc = "a block from [( to ]) (with braces)" },
  { "ap", desc = "a paragraph (with white space) " },
  { "as", desc = "a sentence (with white space)" },
  { "at", desc = "a tag block (with white space)" },
  { "aw", desc = "a word (with white space)" },
  { "a{", desc = "same as aB" },
  { "a}", desc = "same as aB" },
  { "i", group = "inside" },
  { 'i"', desc = "double quoted string without the quotes" },
  { "i'", desc = "single quoted string without the quotes" },
  { "i(", desc = "same as ib" },
  { "i)", desc = "same as ib" },
  { "i<", desc = "inner <> from '<' to the matching '>'" },
  { "i>", desc = "same as i<" },
  { "iB", desc = "inner Block from [{ and ]}" },
  { "iW", desc = "inner WORD" },
  { "i[", desc = "inner [] from '[' to the matching ']'" },
  { "i]", desc = "same as i[" },
  { "i`", desc = "string in backticks without the backticks" },
  { "ib", desc = "inner block from [( to ])" },
  { "ip", desc = "inner paragraph" },
  { "is", desc = "inner sentence" },
  { "it", desc = "inner tag block" },
  { "iw", desc = "inner word" },
  { "i{", desc = "same as iB" },
  { "i}", desc = "same as iB" },
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
}

M.z = {
  preset = true,
  { "z<CR>", desc = "Top this line, 1st non-blank col" },
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
  { "gN", desc = "Search backwards and select" },
  { "gT", desc = "Go to previous tab page" },
  { "gf", desc = "Go to file under cursor" },
  { "gi", desc = "Move to the last insertion and INSERT" },
  { "gn", desc = "Search forwards and select" },
  { "gt", desc = "Go to next tab page" },
  { "gv", desc = "Switch to VISUAL using last selection" },
  { "gx", desc = "Open the file under cursor with system app" },
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
