local M = {}

M.operators_when = {
  ["tildeop"] = {
    ["~"] = "ξ,Ψ_if 'tildeop' on, switch case of text",
  },
}

M.operators = {
  ["c"] = "ξ,ΛΨ_(change) delete text, start insert",
  ["d"] = "ξ,ΛΨ_delete text",
  ["y"] = "ξ,Λ_yank text",
  ["!"] = "ξζ,Ψ_filter text through the ζ command",
  ["<LT>"] = "ξ,Ψ_shift lines one 'shiftwidth' leftwards",
  [">"] = "ξ,Ψ_shift lines one 'shiftwidth' rightwards",
  ["="] = "ξ,Ψ_filter lines through 'equalprg'",
  ["gU"] = "ξ,Ψ_make text uppercase",
  ["gq"] = "ξ,Ψ_format text",
  ["gu"] = "ξ,Ψ_make text lowercase",
  ["gw"] = "ξ,Ψ_format text, keep Δ",
  ["g?"] = "ξ,Ψ_encode with Rot13",
  ["g@"] = "ξ_call 'operatorfunc'",
  ["g~"] = "ξ,Ψ_swap case for text",
  ["zf"] = "ξ_create a fold for text",
}

M.same_as_motions = {
  ["<Tab>"] = { "<C-i>" },
  ["<CR>"] = { "<C-m>", "+" },
  ["h"] = { "<Left>", "<BS>", "<C-h>" },
  ["j"] = { "<Down>", "<NL>", "<C-j>", "<C-n>" },
  ["k"] = { "<Up>", "<C-p>" },
  ["l"] = { "<Right>", "<Space>" },
  ["<Esc>"] = { "<C-[>" },
  ["G"] = { "<C-End>" },
  ["gg"] = { "<C-Home>" },
  ["b"] = { "<C-Left>", "<S-Left>" },
  ["w"] = { "<C-Right>", "<S-Right>" },
  ["$"] = { "<End>" },
  ["0"] = { "<Home>" },
  ["<C-f>"] = { "<S-Down>" },
  ["<C-b>"] = { "<S-Up>" },
  ["[/"] = { "[*" },
  ["]/"] = { "]*" },
  ["gj"] = { "g<Down>" },
  ["gk"] = { "g<Up>" },
  ["g$"] = { "g<End>" },
  ["g0"] = { "g<Home>" },
}

M.not_included_motions = { ["{count}%"] = "Ξ_go to N percentage in the file" }

M.motions_when = {
  ["wrap"] = {
    ["g#"] = "when 'wrap' off go to rightmost character of the current line that is on the screen",
    ["g0"] = "when 'wrap' off go to leftmost character of the current line that is on the screen",
    ["g^"] = "when 'wrap' off go to leftmost non-white character of the current line that is on the screen",
  },
}

M.motions = {
  ["<C-b>"] = "Ξ_scroll N screens Backwards",
  ["<C-f>"] = "Ξ_scroll N screens Forward",
  ["<Tab>"] = "Ξ_go to N newer entry in jump list",
  ["<CR>"] = "Ξ_Δ to the first CHAR N lines lower",
  ["<C-o>"] = "Ξ_go to N older entry in jump list",
  ["#"] = "Ξ_search backward for the Nth occurrence of the identifer",
  ["$"] = "Ξ_Δ to the end of Nth next line",
  ["%"] = "Ξ_go to matching bracket",
  ["("] = "Ξ_Δ N sentences backward",
  [")"] = "Ξ_Δ N sentences forward",
  ["*"] = "Ξ_search forward for the Nth occurrence of the identifer",
  [","] = "Ξ_repeat latest f, t, F or T in other direction N times",
  ["-"] = "Ξ_Δ to the first CHAR N lines higher",
  ["/"] = {
    name = "π,Ξ_search forward for the Nth occurrence of π",
    ["<CR>"] = "Ξ_search forward for π of last search",
  },
  ["0"] = "Ξ_Δ to the first char of the line",
  [":"] = "Ξ_start entering an Ex command",
  [";"] = "Ξ_repeat latest f, t, F or T N times",
  ["?"] = {
    name = "π,Ξ_search backward for the Nth occurrence of π",
    ["<CR>"] = "Ξ_search backward for π of last search",
  },
  ["B"] = "Ξ_Δ N WORDS backward",
  ["E"] = "Ξ_Δ forward to the end of WORD N",
  ["F"] = "δ,Ξ_Δ to the Nth occurrence of δ to the left",
  ["G"] = "Ξ_Δ to line N, default last line",
  ["H"] = "Ξ_Δ to line N from top of screen",
  ["L"] = "Ξ_Δ to line N from bottom of screen",
  ["M"] = "Ξ_Δ to middle line of screen",
  ["N"] = "Ξ_repeat the latest '/' or '?' N times in other direction",
  ["T"] = "δ,Ξ_Δ till after Nth occurrence of δ to the left",
  ["W"] = "Ξ_Δ N WORDS forward",
  ["^"] = "Ξ_Δ to the first CHAR of the line",
  ["_"] = "Ξ_Δ to the first CHAR N - 1 lines lower",
  ["b"] = "Ξ_Δ N words backward",
  ["e"] = "Ξ_Δ forward to the end of word N",
  ["f"] = "δ,Ξ_Δ to Nth occurrence of δ to the right",
  ["h"] = "Ξ_Δ N chars to the left",
  ["j"] = "Ξ_Δ N lines downward",
  ["k"] = "Ξ_Δ N lines upward",
  ["l"] = "Ξ_Δ N chars to the right",
  ["n"] = "Ξ_repeat the latest '/' or '?' N times",
  ["t"] = "δ,Ξ_Δ till before Nth occurrence of δ to the right",
  ["w"] = "Ξ_Δ N words forward",
  ["{"] = "Ξ_Δ N paragraphs backward",
  ["|"] = "Ξ_Δ to column N",
  ["}"] = "Ξ_Δ N paragraphs forward",
  ["[#"] = "Ξ_Δ to N previous unmatched #if, #else or #ifdef",
  ["['"] = "Ξ_Δ to previous lowercase mark, on first non-blank",
  ["[("] = "Ξ_Δ N times back to unmatched '('",
  ["[`"] = "Ξ_Δ to previous lowercase mark",
  ["[/"] = "Ξ_Δ to N previous start of a C comment",
  ["[["] = "Ξ_Δ N sections backward",
  ["[]"] = "Ξ_Δ N SECTIONS backward",
  ["[c"] = "Ξ_Δ N times backwards to start of change",
  ["[m"] = "Ξ_Δ N times back to start of member function",
  ["[s"] = "Ξ_move to the previous misspelled word",
  ["[z"] = "Ξ_move to start of open fold",
  ["[{"] = "Ξ_Δ N times back to unmatched '{'",
  ["]#"] = "Ξ_Δ to N next unmatched #endif or #else",
  ["]'"] = "Ξ_Δ to next lowercase mark, on first non-blank",
  ["])"] = "Ξ_Δ N times forward to unmatched ')'",
  ["]`"] = "Ξ_Δ to next lowercase mark",
  ["]/"] = "Ξ_Δ to N next end of a C comment",
  ["]["] = "Ξ_Δ N SECTIONS forward",
  ["]]"] = "Ξ_Δ N sections forward",
  ["]c"] = "Ξ_Δ N times forward to start of change",
  ["]m"] = "Ξ_Δ N times forward to end of member function",
  ["]s"] = "Ξ_move to next misspelled word",
  ["]z"] = "Ξ_move to end of open fold",
  ["]}"] = "Ξ_Δ N times forward to unmatched '}'",
  ["g#"] = "Ξ_like '#', but without using '\\<' and '\\>'",
  ["g$"] = "Ξ_go to the rightmost character of screen line",
  ["g*"] = "Ξ_like '*', but without using '\\<' and '\\>'",
  ["g,"] = "Ξ_go to N newer position in change list",
  ["g0"] = "Ξ_go to the leftmost character of screen line",
  ["g;"] = "Ξ_go to N older position in change list",
  ["gD"] = "Ξ_go to definition of Δword in current file",
  ["gE"] = "Ξ_go backwards to the end of the previous WORD",
  ["gN"] = "ΞΨ_Visually select the the last search's previous match",
  ["g^"] = "Ξ_go to the leftmost non-white character of screen line",
  ["g_"] = "Ξ_Δ to the last CHAR N - 1 lines lower",
  ["gd"] = "Ξ_go to definition of Δword in current function",
  ["ge"] = "Ξ_go backwards to the end of the previous word",
  ["gg"] = "Ξ_Δ to line N, default first line",
  ["gj"] = "Ξ_like \"j\", but when 'wrap' on go N screen lines down",
  ["gk"] = "Ξ_like \"k\", but when 'wrap' on go N screen lines up",
  ["gm"] = "Ξ_go to character at middle of the screenline",
  ["gM"] = "Ξ_go to character at middle of the text line",
  ["gn"] = "ΞΨ_Visually select the last search's next match",
  ["go"] = "Ξ_Δ to byte N in the buffer",
  ["zj"] = "Ξ_move to the start of the next fold",
  ["zk"] = "Ξ_move to the end of the previous fold",
}

M.same_as_objects = {
  ["ab"] = { "a(", "a)" },
  ["a<"] = { "a>" },
  ["a["] = { "a]" },
  ["aB"] = { "a{", "a{" },
  ["ib"] = { "i(", "i)" },
  ["i<"] = { "i>" },
  ["i["] = { "i]" },
  ["iB"] = { "i{", "i{" },
}

M.objects = {
  a = { name = "around" },
  i = { name = "inside" },
  ['a"'] = "double quoted string",
  ["a'"] = "single quoted string",
  ["a<LT>"] = "'a <>' from '<' to the matching '>'",
  ["aB"] = "'a Block' from '[{' to ']}' (with brackets)",
  ["aW"] = "'a WORD' (with white space)",
  ["a["] = "'a []' from '[' to the matching ']'",
  ["a`"] = "string in backticks",
  ["ab"] = "'a block' from '[(' to '])' (with braces)",
  ["ap"] = "'a paragraph' (with white space)",
  ["as"] = "'a sentence' (with white space)",
  ["at"] = "'a tag block' (with white space)",
  ["aw"] = "'a word' (with white space)",
  ['i"'] = "double quoted string without the quotes",
  ["i'"] = "single quoted string without the quotes",
  ["i<LT>"] = "'inner <>' from '<' to the matching '>'",
  ["iB"] = "'inner Block' from '[{' and ']}'",
  ["iW"] = "'inner WORD'",
  ["i["] = "'inner []' from '[' to the matching ']'",
  ["i`"] = "string in backticks without the backticks",
  ["ib"] = "'inner block' from '[(' to '])'",
  ["ip"] = "'inner paragraph'",
  ["is"] = "'inner sentence'",
  ["it"] = "'inner tag block'",
  ["iw"] = "'inner word'",
}

local operator_pending_mapping = {
  ["v"] = "force operator to work charwise",
  ["V"] = "force operator to work linewise",
  ["<C-v>"] = "force operator to work blockwise",
}

M.completion = {
  ["<C-e>"] = "stop completion, go back to original text",
  ["<C-y>"] = "accept selected match, stop completion",
  ["<C-l>"] = "insert one character from the current match",
  ["<CR>"] = "insert currently selected match",
  ["<BS>"] = "delete one character, redo search",
  ["<Up>"] = "select the previous match",
  ["<Down>"] = "select the next match",
  ["<PageUp>"] = "select a match several entries back",
  ["<PageDown>"] = "select a match several entries forward",
}

local function map(wk, m, mp)
  wk.register(mp, { mode = m, prefix = "", preset = true })
end

function M.setup(wk, config)
  local insert = require("which-key.plugins.presets.extra.insert")
  local normal_misc = require("which-key.plugins.presets.extra.normal-misc")
  local command_line = require("which-key.plugins.presets.extra.command-line")
  if config.mouse ~= false then
    map(wk, "i", insert.mouse)
    map(wk, "n", normal_misc.mouse)
    map(wk, "c", command_line.mouse)
  end
  map(wk, "i", insert.mapping)
  map(wk, "n", normal_misc.mapping)
  map(wk, "c", command_line.mapping)

  local visual = require("which-key.plugins.presets.extra.visual")
  local visual_mapping = vim.tbl_deep_extend("keep", visual.mapping, M.motions)
  map(wk, "v", visual_mapping)

  for op, label in pairs(operator_pending_mapping) do
    local motion = visual_mapping
    motion.name = label
    map(wk, "o", { [op] = motion })
  end
end

return M
