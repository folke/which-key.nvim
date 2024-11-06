local Util = require("which-key.util")

---@class wk.Trigger
---@field buf number
---@field mode string
---@field keys string
---@field plugin? string

local M = {}
M._triggers = {} ---@type table<string, wk.Trigger>
M.suspended = {} ---@type table<wk.Mode, boolean>

M.timer = (vim.uv or vim.loop).new_timer()

--- Checks if a mapping already exists that is not a which-key trigger.
---@param trigger wk.Trigger
function M.is_mapped(trigger)
  ---@type wk.Keymap?
  local km
  pcall(vim.api.nvim_buf_call, trigger.buf, function()
    km = vim.fn.maparg(trigger.keys, trigger.mode, false, true) --[[@as wk.Keymap]]
  end)
  -- not mapped
  if not km or vim.tbl_isempty(km) then
    return false
  end
  -- ignore <Nop> mappings
  if Util.is_nop(km.rhs) then
    return false
  end
  -- ignore which-key triggers
  if km.desc and km.desc:find("which-key-trigger", 1, true) then
    return false
  end
  return true
end

---@param trigger wk.Trigger
function M.add(trigger)
  if M.is_mapped(trigger) then
    return
  end
  vim.keymap.set(trigger.mode, trigger.keys, function()
    require("which-key.state").start({
      keys = trigger.keys,
    })
  end, {
    buffer = trigger.buf,
    nowait = true,
    desc = "which-key-trigger" .. (trigger.plugin and " " .. trigger.plugin or ""),
  })
  M._triggers[M.id(trigger)] = trigger
end

function M.is_active()
  return vim.tbl_isempty(M._triggers)
end

---@param trigger wk.Trigger
function M.del(trigger)
  M._triggers[M.id(trigger)] = nil
  if not vim.api.nvim_buf_is_valid(trigger.buf) then
    return
  end
  if M.is_mapped(trigger) then
    return
  end
  pcall(vim.keymap.del, trigger.mode, trigger.keys, { buffer = trigger.buf })
end

---@param trigger wk.Trigger
function M.id(trigger)
  return trigger.buf .. ":" .. trigger.mode .. ":" .. trigger.keys
end

---@param trigger wk.Trigger
function M.has(trigger)
  return M._triggers[M.id(trigger)] ~= nil
end

---@param mode wk.Mode
---@param triggers? wk.Trigger[]
function M.update(mode, triggers)
  M.cleanup()
  if not mode.buf:valid() then
    for _, trigger in pairs(M._triggers) do
      if trigger.buf == mode.buf.buf then
        M.del(trigger)
      end
    end
    return
  end
  local adds = {} ---@type string[]
  local dels = {} ---@type string[]
  local keep = {} ---@type table<string, boolean>
  for _, node in ipairs(triggers or mode.triggers) do
    ---@type wk.Trigger
    local trigger = {
      buf = mode.buf.buf,
      mode = mode.mode,
      keys = node.keys,
      plugin = node.plugin,
    }
    local id = M.id(trigger)
    keep[id] = true
    if not M.has(trigger) then
      adds[#adds + 1] = trigger.keys
      M.add(trigger)
    end
  end
  for id, trigger in pairs(M._triggers) do
    if trigger.buf == mode.buf.buf and trigger.mode == mode.mode and not keep[id] then
      M.del(trigger)
      dels[#dels + 1] = trigger.keys
    end
  end
  if #adds > 0 then
    Util.debug("Trigger(add) " .. tostring(mode) .. " " .. table.concat(adds, " "))
  end
  if #dels > 0 then
    Util.debug("Trigger(del) " .. tostring(mode) .. " " .. table.concat(dels, " "))
  end
end

---@param mode wk.Mode
function M.attach(mode)
  if M.suspended[mode] then
    return
  end
  M.update(mode)
end

---@param mode wk.Mode
function M.detach(mode)
  M.update(mode, {})
end

---@param mode? wk.Mode
function M.schedule(mode)
  if mode then
    M.suspended[mode] = true
  end
  M.timer:start(
    0,
    0,
    vim.schedule_wrap(function()
      if Util.in_macro() then
        return vim.defer_fn(M.schedule, 100)
      end
      for m, _ in pairs(M.suspended) do
        M.suspended[m] = nil
        M.attach(m)
      end
    end)
  )
end

function M.cleanup()
  for _, trigger in pairs(M._triggers) do
    if not vim.api.nvim_buf_is_valid(trigger.buf) then
      M.del(trigger)
    end
  end
end

---@param mode wk.Mode
function M.suspend(mode)
  Util.debug("suspend", tostring(mode))
  M.detach(mode)
  M.suspended[mode] = true
  M.schedule()
end

return M
