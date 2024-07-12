local M = {}

M.name = "presets"

M.operators = {
  d = "Delete",
  c = "Change",
  y = "Yank (copy)",
  r = "Replace",
  ["~"] = "Toggle case",
  ["g~"] = "Toggle case",
  ["gu"] = "Lowercase",
  ["gU"] = "Uppercase",
  [">"] = "Indent right",
  ["<lt>"] = "Indent left",
  ["zf"] = "Create fold",
  ["!"] = "Filter through external program",
  ["v"] = "Visual Character Mode",
  ["V"] = "Visual Line Mode",
}

M.motions = {
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

M.text_objects = {
  a = { name = "around" },
  i = { name = "inside" },
  ['a"'] = [[double quoted string]],
  ["a'"] = [[single quoted string]],
  ["a("] = [[same as ab]],
  ["a)"] = [[same as ab]],
  ["a<lt>"] = [[a <> from '<' to the matching '>']],
  ["a>"] = [[same as a<]],
  ["aB"] = [[a Block from [{ to ]} (with brackets)]],
  ["aW"] = [[a WORD (with white space)]],
  ["a["] = [[a [] from '[' to the matching ']']],
  ["a]"] = [[same as a[]],
  ["a`"] = [[string in backticks]],
  ["ab"] = [[a block from [( to ]) (with braces)]],
  ["ap"] = [[a paragraph (with white space)]],
  ["as"] = [[a sentence (with white space)]],
  ["at"] = [[a tag block (with white space)]],
  ["aw"] = [[a word (with white space)]],
  ["a{"] = [[same as aB]],
  ["a}"] = [[same as aB]],
  ['i"'] = [[double quoted string without the quotes]],
  ["i'"] = [[single quoted string without the quotes]],
  ["i("] = [[same as ib]],
  ["i)"] = [[same as ib]],
  ["i<lt>"] = [[inner <> from '<' to the matching '>']],
  ["i>"] = [[same as i<]],
  ["iB"] = [[inner Block from [{ and ]}]],
  ["iW"] = [[inner WORD]],
  ["i["] = [[inner [] from '[' to the matching ']']],
  ["i]"] = [[same as i[]],
  ["i`"] = [[string in backticks without the backticks]],
  ["ib"] = [[inner block from [( to ])]],
  ["ip"] = [[inner paragraph]],
  ["is"] = [[inner sentence]],
  ["it"] = [[inner tag block]],
  ["iw"] = [[inner word]],
  ["i{"] = [[same as iB]],
  ["i}"] = [[same as iB]],
}

M.windows = {
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
}

M.z = {
  ["z"] = {
    o = "Open fold under cursor",
    O = "Open all folds under cursor",
    c = "Close fold under cursor",
    C = "Close all folds under cursor",
    d = "Delete fold under cursor",
    D = "Delete all folds under cursor",
    E = "Delete all folds in file",
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
}

M.nav = {
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
}

M.g = {
  ["gf"] = "Go to file under cursor",
  ["gx"] = "Open the file under cursor with system app",
  ["gi"] = "Move to the last insertion and INSERT",
  ["gv"] = "Switch to VISUAL using last selection",
  ["gn"] = "Search forwards and select",
  ["gN"] = "Search backwards and select",
  ["g%"] = "Cycle backwards through results",
  ["gt"] = "Go to next tab page",
  ["gT"] = "Go to previous tab page",
}

function M.setup(opts)
  local wk = require("which-key")

  -- Operators
  if opts.operators then
    wk.register(M.operators, { mode = { "n", "x" }, preset = true })
  end

  -- Motions
  if opts.motions then
    wk.register(M.motions, { mode = "n", preset = true })
    wk.register(M.motions, { mode = "o", preset = true })
  end

  -- Text objects
  if opts.text_objects then
    wk.register(M.text_objects, { mode = "o", preset = true })
  end

  -- Misc
  for _, preset in pairs({ "windows", "nav", "z", "g" }) do
    if opts[preset] ~= false then
      wk.register(M[preset], { mode = "n", preset = true })
    end
  end
end

return M
