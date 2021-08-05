---@class Util
local M = {}

function M.count(tab)
  local ret = 0
  for _, _ in pairs(tab) do
    ret = ret + 1
  end
  return ret
end

function M.get_mode()
  local mode = vim.api.nvim_get_mode().mode
  mode = mode:gsub(M.t("<C-V>"), "v")
  mode = mode:gsub(M.t("<C-S>"), "s")
  return mode:lower()
end

function M.is_empty(tab)
  return M.count(tab) == 0
end

function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

---@return KeyCodes
function M.parse_keys(keystr)
  local keys = {}
  local special = nil
  for i = 1, #keystr, 1 do
    local c = keystr:sub(i, i)
    if c == "<" then
      special = "<"
    elseif c == ">" and special then
      table.insert(keys, special .. ">")
      special = nil
    elseif special then
      special = special .. c
    else
      table.insert(keys, c)
    end
  end
  local ret = { keys = M.t(keystr), term = {}, nvim = {} }
  for i, key in pairs(keys) do
    if key == " " then
      key = "<space>"
    end
    if i == 1 and vim.g.mapleader and M.t(key) == M.t(vim.g.mapleader) then
      key = "<leader>"
    end
    table.insert(ret.term, M.t(key))
    table.insert(ret.nvim, key)
  end
  return ret
end

function M.log(msg, hl)
  vim.api.nvim_echo({ { "WhichKey: ", hl }, { msg } }, true, {})
end

function M.warn(msg)
  M.log(msg, "WarningMsg")
end

function M.error(msg)
  vim.api.nvim_echo({
    { "WhichKey: ", "Error" },
    { msg },
    { " (please report this issue if it persists)", "Comment" },
  }, true, {})
end

function M.check_mode(mode, buf)
  if not ("nvsxoiRct"):find(mode) then
    M.error(string.format("Invalid mode %q for buf %d", mode, buf or 0))
    return false
  end
  return true
end

return M
