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
  -- https://github.com/neovim/neovim/issues/17369
  local ret = vim.api.nvim_replace_termcodes(str, false, true, true):gsub("\128\254X", "\128")
  return ret
end

-- stylua: ignore start
local utf8len_tab = {
  -- ?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9 ?A ?B ?C ?D ?E ?F
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  -- 0?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  -- 1?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  -- 2?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  -- 3?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  -- 4?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  -- 5?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  -- 6?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  -- 7?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  -- 8?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  -- 9?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  -- A?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  -- B?
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,  -- C?
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,  -- D?
  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,  -- E?
  4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 1, 1,  -- F?
}
-- stylua: ignore end

---@return KeyCodes
function M.parse_keys(keystr)
  local keys = {}
  local cur = ""
  local todo = 1
  local special = nil
  for i = 1, #keystr, 1 do
    local c = keystr:sub(i, i)
    if special then
      if todo == 0 then
        if c == ">" then
          table.insert(keys, special .. ">")
          cur = ""
          todo = 1
          special = nil
        elseif c == "-" then
          -- When getting a special key notation:
          --   todo = 0 means it can be ended by a ">" now.
          --   todo = 1 means ">" should be treated as the modified character.
          todo = 1
        end
      else
        todo = 0
      end
      if special then
        special = special .. c
      end
    elseif c == "<" then
      special = "<"
      todo = 0
    else
      if todo == 1 then
        todo = utf8len_tab[c:byte() + 1]
      end
      cur = cur .. c
      todo = todo - 1
      if todo == 0 then
        table.insert(keys, cur)
        cur = ""
        todo = 1
      end
    end
  end
  local ret = { keys = M.t(keystr), internal = {}, notation = {} }
  for i, key in pairs(keys) do
    if key == " " then
      key = "<space>"
    end
    if i == 1 and vim.g.mapleader and M.t(key) == M.t(vim.g.mapleader) then
      key = "<leader>"
    end
    table.insert(ret.internal, M.t(key))
    table.insert(ret.notation, key)
  end
  return ret
end

-- @return string[]
function M.parse_internal(keystr)
  local keys = {}
  local cur = ""
  local todo = 1
  local utf8 = false
  for i = 1, #keystr, 1 do
    local c = keystr:sub(i, i)
    if not utf8 then
      if todo == 1 and c == "\128" then
        -- K_SPECIAL: get 3 bytes
        todo = 3
      elseif cur == "\128" and c == "\252" then
        -- K_SPECIAL KS_MODIFIER: repeat after getting 3 bytes
        todo = todo + 1
      elseif todo == 1 then
        -- When the second byte of a K_SPECIAL sequence is not KS_MODIFIER,
        -- the third byte is guaranteed to be between 0x02 and 0x7f.
        todo = utf8len_tab[c:byte() + 1]
        utf8 = todo > 1
      end
    end
    cur = cur .. c
    todo = todo - 1
    if todo == 0 then
      table.insert(keys, cur)
      cur = ""
      todo = 1
      utf8 = false
    end
  end
  return keys
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
