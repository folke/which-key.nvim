local Keys = require("which-key.keys")

local M = {}

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error
local info = vim.health.info or vim.health.report_info

function M.check()
  start("WhichKey: checking conflicting keymaps")
  local conflicts = 0
  for _, tree in pairs(Keys.mappings) do
    Keys.update_keymaps(tree.mode, tree.buf)
    tree.tree:walk(
      ---@param node Node
      function(node)
        local count = 0
        for _ in pairs(node.children) do
          count = count + 1
        end

        local auto_prefix = not node.mapping or (node.mapping.group == true and not node.mapping.cmd)
        if node.prefix_i ~= "" and count > 0 and not auto_prefix then
          conflicts = conflicts + 1
          local msg = ("conflicting keymap exists for mode **%q**, lhs: **%q**"):format(tree.mode, node.mapping.prefix)
          warn(msg)
          local cmd = node.mapping.cmd or " "
          info(("rhs: `%s`"):format(cmd))
        end
      end
    )
  end
  if conflicts == 0 then
    ok("No conflicting keymaps found")
    return
  end
  for _, dup in ipairs(Keys.duplicates) do
    local msg = ""
    if dup.buf == dup.other.buffer then
      msg = "duplicate keymap"
    else
      msg = "buffer-local keymap overriding global"
    end
    msg = (msg .. " for mode **%q**, buf: %d, lhs: **%q**"):format(dup.mode, dup.buf or 0, dup.prefix)
    if dup.buf == dup.other.buffer then
      error(msg)
    else
      warn(msg)
    end
    info(("old rhs: `%s`"):format(dup.other.rhs or ""))
    info(("new rhs: `%s`"):format(dup.cmd or ""))
  end
end

return M
