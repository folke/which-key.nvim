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
  -- if started with a count, let the default keybinding work
  local count = vim.api.nvim_get_vvar("count")
  if count and count > 0 then return {} end

  local cursor_word = vim.fn.expand("<cword>")
  -- get a misspellled word from under the cursor, if not found, then use the cursor_word instead
  local bad = vim.fn.spellbadword(cursor_word)
  local word = bad[1]
  if word == "" then
    word = cursor_word
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
