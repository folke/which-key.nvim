local M = {}

M.name = "text-objects"

M.triggers = {}

local objects = {
  a = { name = "around" },
  i = { name = "inside" },
  ["a\""] = [["double quoted string]],
  ["a'"] = [["single quoted string]],
  ["a("] = [["same as ab]],
  ["a)"] = [["same as ab]],
  ["a<lt>"] = [[""a <>" from '<' to the matching '>']],
  ["a>"] = [["same as a<]],
  ["aB"] = [[""a Block" from "[{" to "]}" (with brackets)]],
  ["aW"] = [[""a WORD" (with white space)]],
  ["a["] = [[""a []" from '[' to the matching ']']],
  ["a]"] = [["same as a[]],
  ["a`"] = [["string in backticks]],
  ["ab"] = [[""a block" from "[(" to "])" (with braces)]],
  ["ap"] = [[""a paragraph" (with white space)]],
  ["as"] = [[""a sentence" (with white space)]],
  ["at"] = [[""a tag block" (with white space)]],
  ["aw"] = [[""a word" (with white space)]],
  ["a{"] = [["same as aB]],
  ["a}"] = [["same as aB]],
  ["i\""] = [["double quoted string without the quotes]],
  ["i'"] = [["single quoted string without the quotes]],
  ["i("] = [["same as ib]],
  ["i)"] = [["same as ib]],
  ["i<lt>"] = [[""inner <>" from '<' to the matching '>']],
  ["i>"] = [["same as i<]],
  ["iB"] = [[""inner Block" from "[{" and "]}"]],
  ["iW"] = [[""inner WORD"]],
  ["i["] = [[""inner []" from '[' to the matching ']']],
  ["i]"] = [["same as i[]],
  ["i`"] = [["string in backticks without the backticks]],
  ["ib"] = [[""inner block" from "[(" to "])"]],
  ["ip"] = [[""inner paragraph"]],
  ["is"] = [[""inner sentence"]],
  ["it"] = [[""inner tag block"]],
  ["iw"] = [[""inner word"]],
  ["i{"] = [["same as iB]],
  ["i}"] = [["same as iB]],
}

function M.setup()
  local wk = require("which-key")
  wk.register(objects, { mode = "n", prefix = "d" })
  wk.register(objects, { mode = "n", prefix = "c" })
  wk.register(objects, { mode = "n", prefix = "y" })
  wk.register(objects, { mode = "n", prefix = "g~" })
  wk.register(objects, { mode = "n", prefix = "gu" })
  wk.register(objects, { mode = "n", prefix = "gU" })
  wk.register(objects, { mode = "n", prefix = ">" })
  wk.register(objects, { mode = "n", prefix = "<lt>" })
  wk.register(objects, { mode = "n", prefix = "zf" })
  wk.register(objects, { mode = "n", prefix = "v" })
  wk.register(objects, { mode = "v", prefix = "" })
end

return M
