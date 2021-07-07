local M = {}

M.when = {
  ["insertmode"] = {
    ["<C-c>"] = "no-op",
    ["<C-l>"] = "leave insert mode",
    ["<C-z>"] = "suspend Vim",
    ["<Esc>"] = "no-op",
  },
  ["digraph"] = {
    ["{char1}<BS>{char2>"] = "enter digraph (only when 'digraph' option set)",
  },
}

M.not_used = {
  ["<C-f>"] = "not used (but by default it's in 'cinkeys' to re-indent the current line)",
  ["<C-s>"] = "not used or used for terminal control flow",
  ["<C-\\>a-z"] = "reserved for extensions",
  ["<C-\\>others"] = "not used",
  ["<Space> to '~'"] = "not used, except '0' and '^' followed by '<C-D>'",
  ["Meta charcters"] = "(0x80 to 0xff, 128 to 255) not used",
}

M.not_included = {
  ["<C-v>{char}"] = "insert next non-digit literally",
}

M.same_as = {
  ["<C-g>j"] = { "<C-g><C-j>", "<C-g><Down>" },
  ["<C-g>k"] = { "<C-g><C-k>", "<C-g><Up>" },
  ["<BS>"] = { "<C-h>" },
  ["<Tab>"] = { "<C-i>" },
  ["<CR>"] = { "<NL>", "<C-j>", "<C-m>" },
  ["<Esc>"] = { "<C-[>" },
  ["<S-Left>"] = { "<C-Left>" },
  ["<S-Right>"] = { "<C-Right>" },
  ["<S-Up>"] = { "<PageUp>" },
  ["<S-Down>"] = { "<PageDown>" },
  ["<Help>"] = { "<F1>" },
  ["<C-v>{char}"] = { "<C-q>{char}", "<C-S-q>{char}", "<C-S-v>{char}" },
}

M.mode = {
  ["<C-\\>"] = {
    name = "mode",
    ["<C-n>"] = "go to Normal mode",
    ["<C-g>"] = "go to mode specified with 'insertmode'",
  },
}

M.mapping = {
  ["<C-@>"] = "insert previously inserted text, stop insert",
  ["<C-a>"] = "insert previously inserted text",
  ["<C-c>"] = "quit insert mode, without checking for abbreviation",
  ["<C-d>"] = "delete one shiftwidth of indent in the current line",
  ["<C-e>"] = "insert the character which is below Δ",
  ["<C-g>j"] = "line down, to column where inserting started",
  ["<C-g>k"] = "line up, to column where inserting started",
  ["<C-g>u"] = "start new undoable edit",
  ["<C-g>U"] = "don't break undo with next Δ movement",
  ["<BS>"] = "delete character before Δ",
  ["<Tab>"] = "insert a <Tab> character",
  ["<C-k>"] = "δδ_enter digraph",
  ["<CR>"] = "begin new line",
  ["<C-n>"] = "find next match for keyword in front of Δ",
  ["<C-o>"] = "execute a single command, return to insert mode",
  ["<C-p>"] = "find previous match for keyword in front of Δ",
  ["<C-t>"] = "insert one shiftwidth of indent in currentline",
  ["<C-u>"] = "delete all entered characters in the current line",
  ["<C-v>"] = "σσσ_insert three digit decimal number as a single byte",
  ["<C-w>"] = "delete word before Δ",
  ["<C-x>"] = {
    name = "sub",
    ["<C-d>"] = "complete defined identifiers",
    ["<C-e>"] = "scroll up",
    ["<C-f>"] = "complete filenames",
    ["<C-i>"] = "complete identifiers",
    ["<C-k>"] = "complete identifiers from dictionary",
    ["<C-l>"] = "complete whole lines",
    ["<C-n>"] = "next completion",
    ["<C-o>"] = "omni completion",
    ["<C-p>"] = "previous completion",
    ["<C-s>"] = "spelling suggestions",
    ["<C-t>"] = "complete identifiers from thesaurus",
    ["<C-y>"] = "scroll down",
    ["<C-u>"] = "complete with 'completefunc'",
    ["<C-v>"] = "complete like in : command line",
    ["<C-]>"] = "complete tags",
    ["s"] = "spelling suggestions",
  },
  ["<C-y>"] = "insert the character which is above Δ",
  ["<Esc>"] = "end insert mode",
  ["<C-]>"] = "trigger abbreviation",
  ["<C-^>"] = "toggle use of |:lmap| mappings",
  ["<C-_>"] = "when 'allowrevins' set: change language (Hebrew)",
  ["0"] = {
    name = "delete all indent in the current line",
    ["<C-d>"] = "delete all indent in the current line",
  },
  ["^"] = {
    name = "like '0<C-d>', but restore it in the next line",
    ["^<C-d>"] = "like '0<C-d>', but restore it in the next line",
  },
  ["<Del>"] = "delete Δcharacter",
  ["<Help>"] = "stop insert mode, display help window",
  ["<Left>"] = "Δ one character left",
  ["<S-Left>"] = "Δ one word left",
  ["<Right>"] = "Δ one character right",
  ["<S-Right>"] = "Δ one word right",
  ["<Up>"] = "Δ one line up",
  ["<S-Up>"] = "one screenful backward",
  ["<Down>"] = "Δ one line down",
  ["<S-Down>"] = "one screenful forward",
  ["<Home>"] = "Δ to start of line",
  ["<C-Home>"] = "Δ to start of file",
  ["<End>"] = "Δ past end of line",
  ["<C-End>"] = "Δ past end of file",
  ["<Insert>"] = "toggle Insert/Replace mode",
}

M.mouse = {
  ["<LeftMouse>"] = "Δ at mouse click",
  ["<ScrollWheelDown>"] = "move window three lines down",
  ["<S-ScrollWheelDown>"] = "move window one page down",
  ["<ScrollWheelUp>"] = "move window three lines up",
  ["<S-ScrollWheelUp>"] = "move window one page up",
  ["<ScrollWheelLeft>"] = "move window six columns left",
  ["<S-ScrollWheelLeft>"] = "move window one page left",
  ["<ScrollWheelRight>"] = "move window six columns right",
  ["<S-ScrollWheelRight>"] = "move window one page right",
}

return M
