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

function M.in_macro()
  return vim.fn.reg_recording() ~= "" or vim.fn.reg_executing() ~= ""
end

---@param rhs string|fun()
function M.is_nop(rhs)
  return type(rhs) == "string" and (rhs == "" or rhs:lower() == "<nop>")
end

--- Normalizes (and fixes) the lhs of a keymap
---@param lhs string
function M.norm(lhs)
  if M.cache.norm[lhs] then
    return M.cache.norm[lhs]
  end
  M.cache.norm[lhs] = vim.fn.keytrans(M.t(lhs))
  return M.cache.norm[lhs]
end

-- Default register
function M.reg()
  -- this will be set to 2 if there is a non-empty clipboard
  -- tool available
  if vim.g.loaded_clipboard_provider ~= 2 then
    return '"'
  end
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
  if mode:sub(1, 1) == "v" then
    return "x" -- mapmode is actually "x" for visual only mappings
  end
  return mode:sub(1, 1):match("[ncitsxo]") or "n"
end

function M.xo()
  return M.mapmode():find("[xo]") ~= nil
end

---@alias NotifyOpts {level?: number, title?: string, once?: boolean, id?:string}

---@param msg string|string[]
---@param opts? NotifyOpts
function M.notify(msg, opts)
  opts = opts or {}
  msg = type(msg) == "table" and table.concat(msg, "\n") or msg
  ---@cast msg string
  msg = vim.trim(msg)
  return vim[opts.once and "notify_once" or "notify"](msg, opts.level, {
    title = opts.title or "which-key.nvim",
    on_open = function(win)
      M.wo(win, { conceallevel = 3, spell = false, concealcursor = "n" })
      vim.treesitter.start(vim.api.nvim_win_get_buf(win), "markdown")
    end,
  })
end

---@param msg string|string[]
---@param opts? NotifyOpts
function M.warn(msg, opts)
  M.notify(msg, vim.tbl_extend("keep", { level = vim.log.levels.WARN }, opts or {}))
end

---@param msg string|string[]
---@param opts? NotifyOpts
function M.info(msg, opts)
  M.notify(msg, vim.tbl_extend("keep", { level = vim.log.levels.INFO }, opts or {}))
end

---@param msg string|string[]
---@param opts? NotifyOpts
function M.error(msg, opts)
  M.notify(msg, vim.tbl_extend("keep", { level = vim.log.levels.ERROR }, opts or {}))
end

---@generic F: fun()
---@param ms number
---@param fn F
---@return F
function M.debounce(ms, fn)
  local timer = (vim.uv or vim.loop).new_timer()
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

---@param n number buffer or window number
---@param type "win" | "buf"
---@param opts vim.wo | vim.bo
local function set_opts(n, type, opts)
  ---@diagnostic disable-next-line: no-unknown
  for k, v in pairs(opts or {}) do
    ---@diagnostic disable-next-line: no-unknown
    pcall(vim.api.nvim_set_option_value, k, v, type == "win" and {
      scope = "local",
      win = n,
    } or { buf = n })
  end
end

---@param win number
---@param opts vim.wo
function M.wo(win, opts)
  set_opts(win, "win", opts)
end

---@param buf number
---@param opts vim.bo
function M.bo(buf, opts)
  set_opts(buf, "buf", opts)
end

local trace_level = 0
---@param msg? string
---@param ...? any
function M.trace(msg, ...)
  if not msg then
    trace_level = trace_level - 1
    return
  end
  trace_level = math.max(trace_level, 0)
  M.debug(msg, ...)
  trace_level = trace_level + 1
end

---@param msg? string
---@param ...? any
function M.debug(msg, ...)
  if not require("which-key.config").debug then
    return
  end
  local data = { ... }
  if #data == 0 then
    data = nil
  elseif #data == 1 then
    data = data[1]
  end
  if type(data) == "function" then
    data = data()
  end
  if type(data) == "table" then
    data = table.concat(
      vim.tbl_map(function(value)
        return type(value) == "string" and value or vim.inspect(value):gsub("%s+", " ")
      end, data),
      " "
    )
  end
  if data and type(data) ~= "string" then
    data = vim.inspect(data):gsub("%s+", " ")
  end
  msg = data and ("%s: %s"):format(msg, data) or msg
  msg = string.rep("  ", trace_level) .. msg
  M.log(msg .. "\n")
end

function M.log(msg)
  local file = "./wk.log"
  local fd = io.open(file, "a+")
  if not fd then
    error(("Could not open file %s for writing"):format(file))
  end
  fd:write(msg)
  fd:close()
end

--- Returns a function that returns true if the cooldown is active.
--- The cooldown will be active for the given duration or 0 if no duration is given.
--- Runs in the main loop.
--- cooldown(true) will wait till the next tick.
---@return fun(cooldown?: number|boolean): boolean
function M.cooldown()
  local waiting = false
  ---@param cooldown? number|boolean
  return function(cooldown)
    if waiting then
      return true
    elseif cooldown then
      waiting = true
      vim.defer_fn(function()
        waiting = false
      end, type(cooldown) == "number" and cooldown or 0)
    end
    return false
  end
end

---@generic T: table
---@param t T
---@param fields string[]
---@return T
function M.getters(t, fields)
  local getters = {} ---@type table<string, fun():any>
  for _, prop in ipairs(fields) do
    if type(t[prop]) == "function" then
      getters[prop] = t[prop]
      rawset(t, prop, nil)
    end
  end

  if not vim.tbl_isempty(getters) then
    setmetatable(t, {
      __index = function(_, key)
        if getters[key] then
          return getters[key](t)
        end
      end,
    })
  end
end

return M
