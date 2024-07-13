---@module 'luassert'

local Util = require("which-key.util")

describe("parse keys", function()
  local tests = {
    [" <c-a><esc>Ä<lt>🔥foo"] = {
      "<Space>",
      "<C-A>",
      "<Esc>",
      "Ä",
      "<",
      "🔥",
      "f",
      "o",
      "o",
    },
    ["\1<esc>Ä<lt>🔥foo"] = {
      "<C-A>",
      "<Esc>",
      "Ä",
      "<",
      "🔥",
      "f",
      "o",
      "o",
    },
    ["<esc>"] = { "<Esc>" },
    ["foo<baz>"] = { "f", "o", "o", "<", "b", "a", "z", ">" },
    ["foo<bar>"] = { "f", "o", "o", "|" },
    ["foo<a-2>"] = { "f", "o", "o", "<M-2>" },
    ["foo<A-2>"] = { "f", "o", "o", "<M-2>" },
    ["foo<m-2>"] = { "f", "o", "o", "<M-2>" },
    ["foo<M-2>"] = { "f", "o", "o", "<M-2>" },
    ["foo<"] = { "f", "o", "o", "<" },
    ["foo<bar"] = { "f", "o", "o", "<", "b", "a", "r" },
    ["foo>"] = { "f", "o", "o", ">" },
    -- test with japanese chars
    ["fooあ"] = { "f", "o", "o", "あ" },
    ["fooあ<lt>"] = { "f", "o", "o", "あ", "<" },
    ["fooあ<lt>bar"] = { "f", "o", "o", "あ", "<", "b", "a", "r" },
    ["fooあ<lt>bar<lt>"] = { "f", "o", "o", "あ", "<", "b", "a", "r", "<" },
    ["fooあ<lt>bar<lt>baz"] = { "f", "o", "o", "あ", "<", "b", "a", "r", "<", "b", "a", "z" },
    ["fooあ<lt>bar<lt>baz<lt>"] = { "f", "o", "o", "あ", "<", "b", "a", "r", "<", "b", "a", "z", "<" },
    ["fooあ<lt>bar<lt>baz<lt>qux"] = {
      "f",
      "o",
      "o",
      "あ",
      "<",
      "b",
      "a",
      "r",
      "<",
      "b",
      "a",
      "z",
      "<",
      "q",
      "u",
      "x",
    },
    ["fooあ<lt>bar<lt>baz<lt>qux<lt>"] = {
      "f",
      "o",
      "o",
      "あ",
      "<",
      "b",
      "a",
      "r",
      "<",
      "b",
      "a",
      "z",
      "<",
      "q",
      "u",
      "x",
      "<",
    },
  }

  for input, output in pairs(tests) do
    it(("should parse %q"):format(input), function()
      local keys = Util.keys(input)
      assert.same(output, keys)
    end)
  end
end)

describe("modes", function()
  before_each(function()
    require("helpers").reset()
  end)

  local tests = {
    ["gg"] = "n",
    ["vl"] = "x",
    ["<c-v>j"] = "x",
    ["gh"] = "s",
    ["aa"] = "i",
    ["ciw"] = "o",
    ["c"] = "n",
    ["<cmd>terminal exit<cr>"] = "n",
  }

  local inputs = vim.tbl_keys(tests)
  table.sort(inputs)
  for _, input in ipairs(inputs) do
    local output = tests[input]
    it(("should return %q for %q"):format(output, input), function()
      local mode = "n"
      assert.same(mode, Util.mapmode())
      vim.api.nvim_create_autocmd("ModeChanged", {
        once = true,
        callback = function()
          mode = Util.mapmode()
        end,
      })
      vim.api.nvim_feedkeys(vim.keycode(input), "nitx", false)
      assert.same(output, mode)
    end)
  end
end)
