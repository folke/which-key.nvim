local M = {}

M.name = "spelling"

M.actions = { { trigger = "z=", mode = "n" } }

M.opts = {}

function M.setup(_wk, config, options)
  table.insert(options.triggers_nowait, "z=")
  M.opts = config
end

---@type Plugin
---@return PluginItem[]
function M.run(_trigger, _mode, _buf)
  local bad = vim.fn.spellbadword()
  local word = bad[1]

  if word == "" then
    return {}
  end

  local suggestions = vim.fn.spellsuggest(word, M.opts.suggestions or 20, bad[2] == "caps" and 1 or 0)

  local items = {}
  local keys = "1234567890abcdefghijklmnopqrstuvwxyz"

  for i, label in ipairs(suggestions) do
    local key = keys:sub(i, i)

    table.insert(items, { key = key, label = label, fn = function()
      vim.cmd("norm! ciw" .. label)
    end })
  end
  return items
end

return M
