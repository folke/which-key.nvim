---@class Util
local M = {}
local strbyte = string.byte
local strsub = string.sub
---@type table<string, KeyCodes>
local cache = {}
---@type table<string,string>
local tcache = {}
local cache_leaders = ""

function M.check_cache()
  ---@type string
  local leaders = (vim.g.mapleader or "") .. ":" .. (vim.g.maplocalleader or "")
  if leaders ~= cache_leaders then
    cache = {}
    tcache = {}
    cache_leaders = leaders
  end
end

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
  M.check_cache()
  if not tcache[str] then
    -- https://github.com/neovim/neovim/issues/17369
    tcache[str] = vim.api.nvim_replace_termcodes(str, false, true, true):gsub("\128\254X", "\128")
  end
  return tcache[str]
end

-- stylua: ignore start
local utf8len_tab = {
  -- ?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9 ?A ?B ?C ?D ?E ?F
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -- 0?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -- 1?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -- 2?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -- 3?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -- 4?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -- 5?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -- 6?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -- 7?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -- 8?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -- 9?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -- A?
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -- B?
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, -- C?
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, -- D?
  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, -- E?
  4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 1, 1, -- F?
}
-- stylua: ignore end

local Tokens = {
  ["<"] = strbyte("<"),
  [">"] = strbyte(">"),
  ["-"] = strbyte("-"),
}
---@return KeyCodes
function M.parse_keys(keystr)
  M.check_cache()
  if cache[keystr] then
    return cache[keystr]
  end

  local keys = M.t(keystr)
  local internal = M.parse_internal(keys)

  if #internal == 0 then
    local ret = { keys = keys, internal = {}, notation = {} }
    cache[keystr] = ret
    return ret
  end

  local keystr_orig = keystr
  keystr = keystr:gsub("<lt>", "<")
  local notation = {}
  ---@alias ParseState
  --- | "Character"
  --- | "Special"
  --- | "SpecialNoClose"
  local start = 1
  local i = start
  ---@type ParseState
  local state = "Character"
  while i <= #keystr do
    local c = strbyte(keystr, i, i)

    if state == "Character" then
      start = i
      -- Only interpret special tokens if neovim also replaces it
      state = c == Tokens["<"] and internal[#notation + 1] ~= "<" and "Special" or state
    elseif state == "Special" then
      state = (c == Tokens["-"] and "SpecialNoClose") or (c == Tokens[">"] and "Character") or state
    else
      state = "Special"
    end

    i = i + utf8len_tab[c + 1]
    if state == "Character" then
      local k = strsub(keystr, start, i - 1)
      notation[#notation + 1] = k == " " and "<space>" or k
    end
  end

  local mapleader = vim.g.mapleader
  mapleader = mapleader and M.t(mapleader)
  notation[1] = internal[1] == mapleader and "<leader>" or notation[1]

  if #notation ~= #internal then
    error(vim.inspect({ keystr = keystr, internal = internal, notation = notation }))
  end

  local ret = {
    keys = keys,
    internal = internal,
    notation = notation,
  }

  cache[keystr_orig] = ret

  return ret
end

-- @return string[]
function M.parse_internal(keystr)
  local keys = {}
  ---@alias ParseInternalState
  --- | "Character"
  --- | "Special"
  ---@type ParseInternalState
  local state = "Character"
  local start = 1
  local i = 1
  while i <= #keystr do
    local c = strbyte(keystr, i, i)

    if state == "Character" then
      state = c == 128 and "Special" or state
      i = i + utf8len_tab[c + 1]

      if state == "Character" then
        keys[#keys + 1] = strsub(keystr, start, i - 1)
        start = i
      end
    else
      -- This state is entered on the second byte of K_SPECIAL sequence.
      if c == 252 then
        -- K_SPECIAL KS_MODIFIER: skip this byte and the next
        i = i + 2
      else
        -- K_SPECIAL _: skip this byte
        i = i + 1
      end
      -- The last byte of this sequence should be between 0x02 and 0x7f,
      -- switch to Character state to collect.
      state = "Character"
    end
  end
  return keys
end

function M.warn(msg)
  vim.notify(msg, vim.log.levels.WARN, { title = "WhichKey" })
end

function M.error(msg)
  vim.notify(msg, vim.log.levels.ERROR, { title = "WhichKey" })
end

function M.check_mode(mode, buf)
  if not ("nvsxoiRct"):find(mode) then
    M.error(string.format("Invalid mode %q for buf %d", mode, buf or 0))
    return false
  end
  return true
end

return M
