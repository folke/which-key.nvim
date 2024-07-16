local timer = (vim.uv or vim.loop).new_timer()
timer:start(
  500,
  0,
  vim.schedule_wrap(function()
    local wk = require("which-key")
    if not wk.did_setup then
      wk.setup()
    end
  end)
)
