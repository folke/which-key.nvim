local M = {}

M.operators = {
  ["c"] = "ξ_ΛΨ delete text and start insert",
  ["d"] = "ξ_ΛΨ delete text",
  ["y"] = "ξ_Λ yank text",
  ["~"] = "ξ_Ψ if 'tildeop' on, switch case of text", -- todo
  ["!"] = "ξζ_Ψ filter text through the ζ command",
  ["<LT>"] = "ξ_Ψ shift lines one 'shiftwidth' leftwards",
  [">"] = "ξ_Ψ shift lines one 'shiftwidth' rightwards",
  ["="] = "ξ_Ψ filter lines through 'equalprg'",
  ["gU"] = "ξ_Ψ make text uppercase",
  ["gq"] = "ξ_Ψ format text",
  ["gu"] = "ξ_Ψ make text lowercase",
  ["gw"] = "ξ_Ψ format text and keep Δ",
  ["g?"] = "ξ_Ψ encode with Rot13",
  ["g@"] = "ξ call 'operatorfunc'",
  ["g~"] = "ξ_Ψ swap case for text",
  ["zf"] = "ξ create a fold for text",
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

M.not_included_motions = {
  ["{count}%"] = "Ξ go to N percentage in the file",
  ["''"] = "Ξ Δ to the first CHAR of the line where Δ was before the latest jump.",
  ["'("] = "Ξ Δ to the first CHAR on the line of the start of the current sentence",
  ["')"] = "Ξ Δ to the first CHAR on the line of the end of the current sentence",
  ["'<LT>"] = "Ξ Δ to the first CHAR of the line where highlighted area starts/started in the current buffer.",
  ["'>"] = "Ξ Δ to the first CHAR of the line where highlighted area ends/ended in the current buffer.",
  ["'["] = "Ξ Δ to the first CHAR on the line of the start of last operated text or start of put text",
  ["']"] = "Ξ Δ to the first CHAR on the line of the end of last operated text or end of put text",
  ["'{"] = "Ξ Δ to the first CHAR on the line of the start of the current paragraph",
  ["'}"] = "Ξ Δ to the first CHAR on the line of the end of the current paragraph",
  ["`("] = "Ξ Δ to the start of the current sentence",
  ["`)"] = "Ξ Δ to the end of the current sentence",
  ["`<LT>"] = "Ξ Δ to the start of the highlighted area",
  ["`>"] = "Ξ Δ to the end of the highlighted area",
  ["`["] = "Ξ Δ to the start of last operated text or start of putted text",
  ["`]"] = "Ξ Δ to the end of last operated text or end of putted text",
  ["``"] = "Ξ Δ to the position before latest jump",
  ["`{"] = "Ξ Δ to the start of the current paragraph",
  ["`}"] = "Ξ Δ to the end of the current paragraph",
}

M.motions_when = {
  ["wrap"] = {
    ["g#"] = "when 'wrap' off go to rightmost character of the current line that is on the screen",
    ["g0"] = "when 'wrap' off go to leftmost character of the current line that is on the screen",
    ["g^"] = "when 'wrap' off go to leftmost non-white character of the current line that is on the screen",
  },
}

M.motions = {
  ["<C-b>"] = "Ξ scroll N screens Backwards",
  ["<C-f>"] = "Ξ scroll N screens Forward",
  ["<Tab>"] = "Ξ go to N newer entry in jump list",
  ["<CR>"] = "Ξ Δ to the first CHAR N lines lower",
  ["<C-o>"] = "Ξ go to N older entry in jump list",
  ["#"] = "Ξ search backward for the Nth occurrence of the identifer",
  ["$"] = "Ξ Δ to the end of Nth next line",
  ["%"] = "Ξ go to matching bracket",
  ["("] = "Ξ Δ N sentences backward",
  [")"] = "Ξ Δ N sentences forward",
  ["*"] = "Ξ search forward for the Nth occurrence of the identifer",
  [","] = "Ξ repeat latest f, t, F or T in other direction N times",
  ["-"] = "Ξ Δ to the first CHAR N lines higher",
  ["/"] = {
    name = "π_Ξ search forward for the Nth occurrence of π",
    ["<CR>"] = "Ξ search forward for π of last search",
  },
  ["0"] = "Ξ Δ to the first char of the line",
  [":"] = "Ξ start entering an Ex command",
  [";"] = "Ξ repeat latest f, t, F or T N times",
  ["?"] = {
    name = "π_Ξ search backward for the Nth occurrence of π",
    ["<CR>"] = "Ξ search backward for π of last search",
  },
  ["B"] = "Ξ Δ N WORDS backward",
  ["E"] = "Ξ Δ forward to the end of WORD N",
  ["F"] = "δ_Ξ Δ to the Nth occurrence of δ to the left",
  ["G"] = "Ξ Δ to line N, default last line",
  ["H"] = "Ξ Δ to line N from top of screen",
  ["L"] = "Ξ Δ to line N from bottom of screen",
  ["M"] = "Ξ Δ to middle line of screen",
  ["N"] = "Ξ repeat the latest '/' or '?' N times in other direction",
  ["T"] = "δ_Ξ Δ till after Nth occurrence of δ to the left",
  ["W"] = "Ξ Δ N WORDS forward",
  ["^"] = "Ξ Δ to the first CHAR of the line",
  ["_"] = "Ξ Δ to the first CHAR N - 1 lines lower",
  ["b"] = "Ξ Δ N words backward",
  ["e"] = "Ξ Δ forward to the end of word N",
  ["f"] = "δ_Ξ Δ to Nth occurrence of δ to the right",
  ["h"] = "Ξ Δ N chars to the left",
  ["j"] = "Ξ Δ N lines downward",
  ["k"] = "Ξ Δ N lines upward",
  ["l"] = "Ξ Δ N chars to the right",
  ["n"] = "Ξ repeat the latest '/' or '?' N times",
  ["t"] = "δ_Ξ Δ till before Nth occurrence of δ to the right",
  ["w"] = "Ξ Δ N words forward",
  ["{"] = "Ξ Δ N paragraphs backward",
  ["|"] = "Ξ Δ to column N",
  ["}"] = "Ξ Δ N paragraphs forward",
  ["[#"] = "Ξ Δ to N previous unmatched #if, #else or #ifdef",
  ["['"] = "Ξ Δ to previous lowercase mark, on first non-blank",
  ["[("] = "Ξ Δ N times back to unmatched '('",
  ["[`"] = "Ξ Δ to previous lowercase mark",
  ["[/"] = "Ξ Δ to N previous start of a C comment",
  ["[["] = "Ξ Δ N sections backward",
  ["[]"] = "Ξ Δ N SECTIONS backward",
  ["[c"] = "Ξ Δ N times backwards to start of change",
  ["[m"] = "Ξ Δ N times back to start of member function",
  ["[s"] = "Ξ move to the previous misspelled word",
  ["[z"] = "Ξ move to start of open fold",
  ["[{"] = "Ξ Δ N times back to unmatched '{'",
  ["]#"] = "Ξ Δ to N next unmatched #endif or #else",
  ["]'"] = "Ξ Δ to next lowercase mark, on first non-blank",
  ["])"] = "Ξ Δ N times forward to unmatched ')'",
  ["]`"] = "Ξ Δ to next lowercase mark",
  ["]/"] = "Ξ Δ to N next end of a C comment",
  ["]["] = "Ξ Δ N SECTIONS forward",
  ["]]"] = "Ξ Δ N sections forward",
  ["]c"] = "Ξ Δ N times forward to start of change",
  ["]m"] = "Ξ Δ N times forward to end of member function",
  ["]s"] = "Ξ move to next misspelled word",
  ["]z"] = "Ξ move to end of open fold",
  ["]}"] = "Ξ Δ N times forward to unmatched '}'",
  ["g#"] = "Ξ like \"#\", but without using \"\\<\" and \"\\>\"",
  ["g$"] = "Ξ go to the rightmost character of screen line",
  ["g*"] = "Ξ like \"*\", but without using \"\\<\" and \"\\>\"",
  ["g,"] = "Ξ go to N newer position in change list",
  ["g0"] = "Ξ go to the leftmost character of screen line",
  ["g;"] = "Ξ go to N older position in change list",
  ["gD"] = "Ξ go to definition of Δword in current file",
  ["gE"] = "Ξ go backwards to the end of the previous WORD",
  ["gN"] = "ΞΨ Visually select the the last search's previous match",
  ["g^"] = "Ξ go to the leftmost non-white character of screen line",
  ["g_"] = "Ξ Δ to the last CHAR N - 1 lines lower",
  ["gd"] = "Ξ go to definition of Δword in current function",
  ["ge"] = "Ξ go backwards to the end of the previous word",
  ["gg"] = "Ξ Δ to line N, default first line",
  ["gj"] = "Ξ like \"j\", but when 'wrap' on go N screen lines down",
  ["gk"] = "Ξ like \"k\", but when 'wrap' on go N screen lines up",
  ["gm"] = "Ξ go to character at middle of the screenline",
  ["gM"] = "Ξ go to character at middle of the text line",
  ["gn"] = "ΞΨ Visually select the last search's next match",
  ["go"] = "Ξ Δ to byte N in the buffer",
  ["zj"] = "Ξ move to the start of the next fold",
  ["zk"] = "Ξ move to the end of the previous fold",
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
  ["a\""] = "double quoted string",
  ["a'"] = "single quoted string",
  ["a<LT>"] = "\"a <>\" from '<' to the matching '>'",
  ["aB"] = "\"a Block\" from \"[{\" to \"]}\" (with brackets)",
  ["aW"] = "\"a WORD\" (with white space)",
  ["a["] = "\"a []\" from '[' to the matching ']'",
  ["a`"] = "string in backticks",
  ["ab"] = "\"a block\" from \"[(\" to \"])\" (with braces)",
  ["ap"] = "\"a paragraph\" (with white space)",
  ["as"] = "\"a sentence\" (with white space)",
  ["at"] = "\"a tag block\" (with white space)",
  ["aw"] = "\"a word\" (with white space)",
  ["i\""] = "double quoted string without the quotes",
  ["i'"] = "single quoted string without the quotes",
  ["i<LT>"] = "\"inner <>\" from '<' to the matching '>'",
  ["iB"] = "\"inner Block\" from \"[{\" and \"]}\"",
  ["iW"] = "\"inner WORD\"",
  ["i["] = "\"inner []\" from '[' to the matching ']'",
  ["i`"] = "string in backticks without the backticks",
  ["ib"] = "\"inner block\" from \"[(\" to \"])\"",
  ["ip"] = "\"inner paragraph\"",
  ["is"] = "\"inner sentence\"",
  ["it"] = "\"inner tag block\"",
  ["iw"] = "\"inner word\"",
}

local operator_pending_mapping = {
  ["v"] = "force operator to work charwise",
  ["V"] = "force operator to work linewise",
  ["<C-v>"] = "force operator to work blockwise",
}

-- CTRL-E	stop completion and go back to original text
-- CTRL-Y	accept selected match and stop completion
-- 		CTRL-L		insert one character from the current match
-- 		<CR>		insert currently selected match
-- 		<BS>		delete one character and redo search
-- 		CTRL-H		same as <BS>
-- 		<Up>		select the previous match
-- 		<Down>		select the next match
-- 		<PageUp>	select a match several entries back
-- 		<PageDown>	select a match several entries forward
-- 		other		stop completion and insert the typed character

local function map(wk, m, mp) wk.register(mp, { mode = m, prefix = "", preset = true }) end

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
    motion.name = label;
    map(wk, "o", { [op] = motion })
  end
end

return M
