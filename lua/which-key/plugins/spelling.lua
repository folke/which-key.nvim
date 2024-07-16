---@diagnostic disable: missing-fields, inject-field
---@type wk.Plugin
local M = {}

M.name = "spelling"

M.mappings = {
  {
    "z=",
    icon = { icon = " ", color = "red" },
    plugin = "spelling",
    desc = "Spelling Suggestions",
  },
}

---@type table<string, any>
M.opts = {}

function M.setup(opts)
  M.opts = opts
end

function M.expand()
  -- if started with a count, let the default keybinding work
  local count = vim.v.count
  if count and count > 0 then
    return {}
  end

  local cursor_word = vim.fn.expand("<cword>")
  -- get a misspelled word from under the cursor, if not found, then use the cursor_word instead
  local bad = vim.fn.spellbadword(cursor_word)
  local word = bad[1] == "" and cursor_word or bad[1]

  ---@type string[]
  local suggestions = vim.fn.spellsuggest(word, M.opts.suggestions or 20, bad[2] == "caps" and 1 or 0)

  local items = {} ---@type wk.Plugin.item[]
  local keys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

  for i, label in ipairs(suggestions) do
    local key = keys:sub(i, i)

    table.insert(items, {
      key = key,
      desc = label,
      action = function()
        vim.cmd("norm! " .. i .. "z=")
      end,
    })
  end
  return items
end

return M
