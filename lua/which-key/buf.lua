local Config = require("which-key.config")
local Tree = require("which-key.tree")
local Util = require("which-key.util")

---@class wk.Mode
---@field buf wk.Buffer
---@field mode string
---@field tree wk.Tree
---@field triggers table<string, wk.Node>
local Mode = {}
Mode.__index = Mode

---@param node wk.Node
local function needs_trigger(node)
  if node and node.plugin then
    return false
  end
  if node.keymap or not Tree.is_group(node) then
    return false
  end
  if #node.path == 1 then
    local key = node.path[1]
    if key:match("^[a-z]$") and not key:match("^[gz]$") then
      return false
    end
  end
  return true
end

function Mode:__tostring()
  return string.format("Mode(%s)", self.mode)
end

---@param buf wk.Buffer
---@param mode string
function Mode.new(buf, mode)
  local self = setmetatable({}, Mode)
  self.buf = buf
  self.mode = mode
  self.tree = Tree.new()
  self.triggers = {}
  self:update()
  return self
end

function Mode:attach()
  -- NOTE: order is important for nowait to work!
  -- * first add plugin mappings
  -- * then add triggers
  self.tree:walk(function(node)
    if node.plugin then
      self:_attach(node)
      return false
    end
  end)
  if Config.triggers then
    self.tree:walk(function(node)
      if needs_trigger(node) then
        self:_attach(node)
        return false
      end
    end)
  end
end

function Mode:detach()
  for _, node in pairs(self.triggers) do
    self:_detach(node)
  end
end

---@param node wk.Node
function Mode:reattach(node)
  Util.debug("reattach", node.keys, self.mode)
  while node do
    if self:is_trigger(node.keys) then
      local trigger = node
      Util.debug("detach", trigger.keys)
      self:_detach(trigger)
      vim.schedule(function()
        Util.debug("attach", trigger.keys, self.mode)
        self:_attach(trigger)
      end)
    end
    node = node.parent
  end
end

---@param node wk.Node
function Mode:_attach(node)
  if not self.buf:valid() then
    return
  end
  local ctx = {
    mode = self.mode,
    keys = node.keys,
    plugin = node.plugin,
  }
  if Config.disable.trigger(ctx) then
    return
  end
  self.triggers[node.keys] = node
  local delay = require("which-key.state").delay(ctx)
  local waited = vim.o.timeout and delay >= vim.o.timeoutlen and vim.o.timeoutlen or 0
  vim.keymap.set(self.mode, node.keys, function()
    require("which-key.state").start({
      keys = node.keys,
      waited = waited,
    })
  end, {
    buffer = self.buf.buf,
    nowait = waited == 0,
    desc = "which-key " .. (node.plugin or "trigger"),
  })
end

---@param node wk.Node
function Mode:_detach(node)
  if not self:is_trigger(node.keys) then
    return false
  end
  self.triggers[node.keys] = nil
  pcall(vim.keymap.del, self.mode, node.keys, { buffer = self.buf.buf })
  return true
end

function Mode:is_trigger(lhs)
  return self.triggers[lhs] ~= nil
end

function Mode:clear()
  self:detach()
  self.tree:clear()
end

function Mode:update()
  self:clear()

  local mappings = vim.api.nvim_get_keymap(self.mode)
  vim.list_extend(mappings, vim.api.nvim_buf_get_keymap(self.buf.buf, self.mode))
  ---@cast mappings wk.Keymap[]

  for _, mapping in ipairs(mappings) do
    if mapping.rhs == "" or mapping.rhs == "<Nop>" then
      self.tree:add(mapping, true)
    elseif mapping.lhs:sub(1, 6) ~= "<Plug>" and mapping.lhs:sub(1, 5) ~= "<SNR>" then
      self.tree:add(mapping)
    end
  end

  local modes = { [self.mode] = true }
  if self.mode == "s" then
    modes.v = true
  elseif self.mode == "x" then
    modes.v = true
  end
  for _, m in ipairs(Config.mappings) do
    if modes[m.mode] and (not m.buffer or m.buffer == self.buf.buf) then
      self.tree:add(m, true)
    end
  end

  self.tree:fix()
  self:attach()
  vim.schedule(function()
    require("which-key.state").update()
  end)
end

---@class wk.Buffer
---@field buf number
---@field modes table<string, wk.Mode>
local Buf = {}
Buf.__index = Buf

---@param buf? number
function Buf.new(buf)
  local self = setmetatable({}, Buf)
  buf = buf or 0
  self.buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
  self.modes = {}
  return self
end

---@param opts? wk.Filter
function Buf:clear(opts)
  opts = opts or {}
  assert(not opts.buf or opts.buf == self.buf, "buffer mismatch")
  ---@type string[]
  local modes = opts.mode and { opts.mode } or vim.tbl_keys(self.modes)
  for _, m in ipairs(modes) do
    local mode = self.modes[m]
    if mode then
      mode:clear()
      self.modes[m] = nil
    end
  end
end

function Buf:valid()
  return vim.api.nvim_buf_is_valid(self.buf)
end

---@param opts? wk.Filter
---@return wk.Mode?
function Buf:get(opts)
  if not self:valid() then
    return
  end
  opts = opts or {}
  local mode = opts.mode or Util.mapmode()
  if not Config.modes[mode] then
    return
  end
  local ret = self.modes[mode]
  if not ret then
    self.modes[mode] = Mode.new(self, mode)
    return self.modes[mode]
  elseif opts.update then
    ret:update()
  end
  return ret
end

local M = {}
M.Buf = Buf
M.bufs = {} ---@type table<number,wk.Buffer>

---@param opts? wk.Filter
function M.get(opts)
  M.cleanup()
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local ft = vim.bo[buf].filetype
  local bt = vim.bo[buf].buftype

  if vim.tbl_contains(Config.disable.ft, ft) then
    return
  end
  if vim.tbl_contains(Config.disable.bt, bt) then
    return
  end

  M.bufs[buf] = M.bufs[buf] or Buf.new(buf)
  return M.bufs[buf]:get(opts)
end

function M.cleanup()
  for buf, _ in pairs(M.bufs) do
    if not vim.api.nvim_buf_is_valid(buf) then
      M.bufs[buf] = nil
    end
  end
end

---@param opts? wk.Filter
function M.clear(opts)
  M.cleanup()
  opts = opts or {}
  ---@type number[]
  local bufs = opts.buf and { opts.buf } or vim.tbl_keys(M.bufs)
  for _, b in ipairs(bufs) do
    if M.bufs[b] then
      M.bufs[b]:clear(opts)
    end
  end
  M.check()
end

M.check = Util.debounce(50, function()
  M.get()
end)

return M
