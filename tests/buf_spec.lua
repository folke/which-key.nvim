local Buf = require("which-key.buf")

before_each(function()
  require("helpers").reset()
end)

describe("triggers", function()
  it("does not create hooks for default mappings", function()
    vim.keymap.set("n", "aa", "<nop>")
    Buf.get({ mode = "n" })
    local m = vim.fn.maparg("a", "n", false, true)
    assert.same(vim.empty_dict(), m)
  end)
end)
