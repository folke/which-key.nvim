local M = {}

M.when = {
  ["cedit"] = { ["<C-f>"] = "no-op", ["cedit value"] = "opens the command-line window" },
  ["wildchar"] = { ["<Tab>"] = "no-op", ["wildchar value"] = "do completion on patternΔ" },
  ["digraph"] = {
    ["{char1}<BS>{char2}"] = "enter digraph when 'digraph' is on",
  },
}

M.not_used = {
  ["<C-@>"] = "not used",
  ["<C-o>"] = "not used",
  ["<C-s>"] = "not used or used for terminal control flow",
  ["<C-x>"] = "not used (reserved for completion)",
  ["<C-z>"] = "not used (reserved for suspend)",
  ["<C-\\>a-d"] = "reserved for extensions",
  ["<C-\\>f-z"] = "reserved for extensions",
  ["<C-\\>others"] = "not used",
}

M.not_included = {
  ["<C-v>{char}"] = "insert next non-digit literally",
}

M.same_as = {
  ["<BS>"] = { "<C-h>" },
  ["<Tab>"] = { "<C-i>" },
  ["<CR>"] = { "<NL>", "<C-j>", "<C-m>" },
  ["<Esc>"] = { "<C-c>", "<C-[>" },
  ["<C-p>"] = "<S-Tab>",
  ["<S-Left>"] = { "<C-Left>" },
  ["<S-Right>"] = { "<C-Right>" },
  ["<S-Up>"] = { "<PageUp>" },
  ["<S-Down>"] = { "<PageDown>" },
  ["<C-v>{char}"] = { "<C-q>{char}", "<C-S-q>{char}", "<C-S-v>{char}" },
}

M.mode = {
  ["<C-\\>"] = {
    name = "mode",
    ["<C-n>"] = "go to Normal mode, abandon command-line",
    ["<C-g>"] = "go to mode specified with 'insertmode', abandon command-line",
  },
}

M.mapping = {
  ["<C-a>"] = "do completion on patternΔ, insert all matches",
  ["<C-b>"] = "Δ to begin of command-line",
  ["<C-d>"] = "list completions that match patternΔ",
  ["<C-e>"] = "Δ to end of command-line",
  ["<C-f>"] = "opens the command-line window",
  ["<C-g>"] = "next match when 'incsearch' is active",
  ["<BS>"] = "delete characterΔ",
  ["<Tab>"] = "do completion on patternΔ",
  ["<C-k>"] = "δδ_enter digraph",
  ["<C-l>"] = "do completion on patternΔ, insert the longest common part",
  ["<CR>"] = "execute entered command",
  ["<C-n>"] = "go to next wildchar match or recall older command-line",
  ["<C-p>"] = "go to previous wildchar match or recall older command-line",
  ["<C-t>"] = "previous match when 'incsearch' is active",
  ["<C-u>"] = "remove all characters",
  ["<C-v>"] = "σσσ_insert three digit decimal number as a single byte",
  ["<C-w>"] = "delete wordΔ",
  ["<C-y>"] = "copy (yank) modeless selection",
  ["<Esc>"] = "abandon command-line without executing it",
  ["<C-\\>"] = {
    name = "ε_replace the command line with the result of ε",
    ["e"] = "ε_replace the command line with the result of ε",
  },
  ["<C-]>"] = "trigger abbreviation",
  ["<C-^>"] = "toggle use of |:lmap| mappings",
  ["<C-_>"] = "when 'allowrevins' set: change language (Hebrew)",
  ["<Del>"] = "delete the Δcharacter",
  ["<Left>"] = "Δ left",
  ["<S-Left>"] = "Δ one word left",
  ["<Right>"] = "Δ right",
  ["<S-Right>"] = "Δ one word right",
  ["<Up>"] = "recall previous command-line that matches patternΔ",
  ["<S-Up>"] = "recall previous command-line",
  ["<Down>"] = "recall next command-line that matches patternΔ",
  ["<S-Down>"] = "recall next command-line",
  ["<Home>"] = "Δ to start of command-line",
  ["<End>"] = "Δ to end of command-line",
  ["<Insert>"] = "toggle insert/overstrike mode",
}

M.mouse = { ["<LeftMouse>"] = "Δ at mouse click" }

return M
