local Mappings = require("which-key.mappings")

describe("specs", function()
  local tests = {
    {
      spec = {
        ["<leader>"] = {
          name = "leader",
          ["a"] = { "a" },
          ["b"] = { "b" },
          ["c"] = { "c" },
        },
      },
      mappings = {
        { lhs = "<leader>", group = true, desc = "leader", mode = "n" },
        { lhs = "<leader>a", desc = "a", mode = "n" },
        { lhs = "<leader>b", desc = "b", mode = "n" },
        { lhs = "<leader>c", desc = "c", mode = "n" },
      },
    },
    {
      spec = {
        mode = "v",
        ["<leader>"] = {
          name = "leader",
          ["a"] = { "a" },
          ["b"] = { "b" },
          ["c"] = { "c" },
        },
      },
      mappings = {
        { lhs = "<leader>", group = true, desc = "leader", mode = "v" },
        { lhs = "<leader>a", desc = "a", mode = "v" },
        { lhs = "<leader>b", desc = "b", mode = "v" },
        { lhs = "<leader>c", desc = "c", mode = "v" },
      },
    },
    {
      spec = { desc = "foo", noremap = true },
      mappings = {
        { lhs = "", desc = "foo", remap = false, mode = "n" },
      },
    },
    {
      spec = { a = { desc = "which_key_ignore" } },
      mappings = {
        { lhs = "a", hidden = true, mode = "n" },
      },
    },
    {
      spec = { a = { "foo", cond = false } },
      mappings = {},
    },
    {
      spec = { a = { "foo", cond = true } },
      mappings = {
        { desc = "foo", lhs = "a", mode = "n" },
      },
    },
    {
      spec = {
        a = { "a", cmd = "aa" },
        b = { "b", callback = "bb" },
        c = { "cc", "c" },
        d = { "dd", desc = "d" },
      },
      mappings = {
        { lhs = "a", desc = "a", rhs = "aa", mode = "n", silent = true },
        { lhs = "b", desc = "b", rhs = "bb", mode = "n", silent = true },
        { lhs = "c", desc = "c", rhs = "cc", mode = "n", silent = true },
        { lhs = "d", desc = "d", rhs = "dd", mode = "n", silent = true },
      },
    },
    {
      spec = {
        a = { "a1" },
        b = { "b1", "b2" },
        c = { "c1", desc = "c2" },
      },
      mappings = {
        { lhs = "a", desc = "a1", mode = "n" },
        { lhs = "b", desc = "b1", mode = "n" },
        { lhs = "c", desc = "c2", mode = "n" },
      },
    },
  }

  -- Function to run the tests
  for t, test in ipairs(tests) do
    it(tostring(t), function()
      local result = Mappings.parse(test.spec)
      assert.same(test.mappings, result)
    end)
  end
end)
