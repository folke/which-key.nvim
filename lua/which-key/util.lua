local M = {}

M.cache = {
  keys = {}, ---@type table<string, string[]>
  norm = {}, ---@type table<string, string>
  termcodes = {}, ---@type table<string, string>
}

function M.t(str)
  M.cache.termcodes[str] = M.cache.termcodes[str] or vim.api.nvim_replace_termcodes(str, true, true, true)
  return M.cache.termcodes[str]
end

M.CR = M.t("<cr>")
M.ESC = M.t("<esc>")
M.BS = M.t("<bs>")
M.EXIT = M.t("<C-\\><C-n>")
M.LUA_CALLBACK = "\x80\253g"
M.CMD = "\x80\253h"

function M.exit()
  vim.api.nvim_feedkeys(M.EXIT, "n", false)
  vim.api.nvim_feedkeys(M.ESC, "n", false)
end

--- Normalizes (and fixes) the lhs of a keymap
---@param lhs string
function M.norm(lhs)
  M.cache.norm[lhs] = M.cache.norm[lhs] or vim.fn.keytrans(M.t(lhs))
  return M.cache.norm[lhs]
end

-- Default register
function M.reg()
  local cb = vim.o.clipboard
  return cb:find("unnamedplus") and "+" or cb:find("unnamed") and "*" or '"'
end

--- Returns the keys of a keymap, taking multibyte and special keys into account
---@param lhs string
---@param opts? {norm?: boolean}
function M.keys(lhs, opts)
  lhs = opts and opts.norm == false and lhs or M.norm(lhs)
  if M.cache.keys[lhs] then
    return M.cache.keys[lhs]
  end
  local ret = {} ---@type string[]
  local bytes = vim.fn.str2list(lhs) ---@type number[]
  local special = nil ---@type string?
  for _, byte in ipairs(bytes) do
    local char = vim.fn.nr2char(byte) ---@type string
    if char == "<" then
      special = "<"
    elseif special then
      special = special .. char
      if char == ">" then
        ret[#ret + 1] = special == "<lt>" and "<" or special
        special = nil
      end
    else
      ret[#ret + 1] = char
    end
  end

  M.cache.keys[lhs] = ret
  return ret
end

---@param mode? string
function M.mapmode(mode)
  mode = mode or vim.api.nvim_get_mode().mode
  mode = mode:gsub(M.t("<C-V>"), "v"):gsub(M.t("<C-S>"), "s"):lower()
  if mode:sub(1, 2) == "no" then
    return "o"
  end
  if mode:sub(1, 2) == "nt" then
    return "t"
  end
  if mode:sub(1, 1) == "v" then
    return "x" -- mapmode is actually "x" for visual only mappings
  end
  return mode:sub(1, 1):match("[ncits]") or "n"
end

function M.xo()
  return M.mapmode():find("[xo]") ~= nil
end

function M.safe()
  return vim.fn.reg_recording() == "" and vim.fn.reg_executing() == ""
end

---@param msg string
function M.warn(msg)
  vim.notify(msg, vim.log.levels.WARN, { title = "WhichKey" })
end

---@param msg string
function M.error(msg)
  vim.notify(msg, vim.log.levels.ERROR, { title = "WhichKey" })
end

---@generic F: fun()
---@param ms number
---@param fn F
---@return F
function M.debounce(ms, fn)
  local timer = vim.uv.new_timer()
  return function(...)
    local args = { ... }
    timer:start(
      ms,
      0,
      vim.schedule_wrap(function()
        fn(args)
      end)
    )
  end
end

---@param opts? {msg?: string}
function M.try(fn, opts)
  local ok, err = pcall(fn)
  if not ok then
    local msg = opts and opts.msg or "Something went wrong:"
    msg = msg .. "\n" .. err
    M.error(msg)
  end
end

---@param buf number
---@param row number
---@param ns number
---@param col number
---@param opts vim.api.keyset.set_extmark
---@param debug_info? any
function M.set_extmark(buf, ns, row, col, opts, debug_info)
  local ok, err = pcall(vim.api.nvim_buf_set_extmark, buf, ns, row, col, opts)
  if not ok then
    M.error(
      "Failed to set extmark for preview:\n"
        .. vim.inspect({ info = debug_info, row = row, col = col, opts = opts, error = err })
    )
  end
end

---@param data any
function M.debug(data)
  if type(data) == "function" then
    data = data()
  end
  if type(data) ~= "string" then
    data = vim.inspect(data)
  end
  local file = "./wk.log"
  local fd = io.open(file, "a+")
  if not fd then
    error(("Could not open file %s for writing"):format(file))
  end
  fd:write(data .. "\n")
  fd:close()
end

return M
