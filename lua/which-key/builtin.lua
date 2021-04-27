local builtin = {
  ["<c-w>"] = {
    name = "+window",
    s = "Split window",
    v = "Split window vertically",
    w = "Switch windows",
    q = "Quit a window",
    T = "Break out into a new tab",
    x = "Swap current with next",
    ["-"] = "Decrease height",
    ["+"] = "Increase height",
    ["<lt>"] = "Decrease width",
    [">"] = "Increase width",
    ["|"] = "Max out the width",
    ["="] = "Equally high and wide",
    h = "Go to the left window",
    l = "Go to the right window",
    k = "Go to the up window",
    j = "Go to the down window",
  },
}

return builtin
