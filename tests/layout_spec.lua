local layout = require("which-key.layout")

describe("dim", function()
  local tests = {
    { 100, { parent = 200 }, 100 },
    { 0.2, { parent = 100 }, 20 },
    { -0.2, { parent = 100 }, 80 },
    { -20, { parent = 100 }, 80 },
    { 1, { parent = 100 }, 100 },
    -- now some tests with min/max
    { 100, { parent = 200, min = 50 }, 100 },
    { 100, { parent = 200, max = 150 }, 100 },
    { 100, { parent = 200, min = 50, max = 150 }, 100 },
    { 100, { parent = 200, min = 150, max = 150 }, 150 },
    -- now the combo
    { 0.2, { parent = 100, min = 20, max = 150 }, 20 },
    { 0.2, { parent = 100, min = 20, max = 50 }, 20 },
    { -0.5, { parent = 200 }, 100 },
    { 0.5, { parent = 200 }, 100 },
    { 0.5, { parent = 200, min = 150 }, 150 },
    { -0.5, { parent = 200, max = 50 }, 50 },
    { 300, { parent = 200, max = 250 }, 250 },
    { 300, { parent = 200, min = 250 }, 300 },
    { -100, { parent = 100, min = 20, max = 90 }, 20 },
    { -200, { parent = 100, min = -50, max = -50 }, 50 },
    { 0.2, { parent = 100, min = 0.5 }, 50 },
    { -200, { parent = 100 }, 0 },
  }

  for _, test in ipairs(tests) do
    it("should return " .. test[3] .. " when given " .. test[1], function()
      assert.are.equal(test[3], layout.dim(test[1], test[2]))
    end)
  end
end)
