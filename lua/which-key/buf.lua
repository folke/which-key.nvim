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
  if node.keymap or not node.children then
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
  self.tree:walk(function(node)
    if needs_trigger(node) then
      self:_attach(node)
      return false
    end
  end)
end

function Mode:detach()
  for _, node in pairs(self.triggers) do
    self:_detach(node)
  end
end

---@param node wk.Node
function Mode:reattach(node)
  while node do
    local lhs = table.concat(node.path)
    if self:is_trigger(lhs) then
      local trigger = node
      self:_detach(trigger)
      vim.schedule(function()
        self:_attach(trigger)
      end)
    end
    node = node.parent
  end
end

---@param node wk.Node
function Mode:_attach(node)
  local lhs = table.concat(node.path)
  self.triggers[lhs] = node
  vim.keymap.set(self.mode, lhs, function()
    require("which-key.state").start(node)
  end, { buffer = self.buf.buf, nowait = true, desc = "which-key trigger" })
  return lhs
end

---@param node wk.Node
function Mode:_detach(node)
  local lhs = table.concat(node.path)
  if not self:is_trigger(lhs) then
    return false
  end
  self.triggers[lhs] = nil
  pcall(vim.keymap.del, self.mode, lhs, { buffer = self.buf.buf })
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
      mapping.virtual = true
    end
  end

  for _, m in ipairs(Config.mappings) do
    if m.mode == self.mode and (not m.buffer or m.buffer == self.buf) then
      table.insert(mappings, m)
    end
  end

  self.tree:add(mappings --[[@as wk.Keymap[] ]])
  self:attach()
  require("which-key.state").update()
end

---@class wk.Buffer
---@field buf number
---@field modes table<string, wk.Mode>
local Buf = {}
Buf.__index = Buf

local M = {}
M.Buf = Buf
M.bufs = {} ---@type table<number,wk.Buffer>

---@param opts? {buf?: number, mode?:string, update?:boolean}
function M.get(opts)
  M.cleanup()
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  if vim.bo[buf].buftype == "nofile" then
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

function M.reset()
  M.cleanup()
  for _, buf in pairs(M.bufs) do
    buf:reset()
  end
end

---@param buf? number
function Buf.new(buf)
  local self = setmetatable({}, Buf)
  buf = buf or 0
  self.buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
  self.modes = {}
  -- self.update = Util.debounce(300, function()
  --   M.update(self)
  -- end)
  return self
end

function Buf:reset()
  for _, mode in pairs(self.modes) do
    mode:update()
  end
end

function Buf:valid()
  return vim.api.nvim_buf_is_valid(self.buf)
end

---@param opts? {mode?:string, update?:boolean}
---@return wk.Mode?
function Buf:get(opts)
  if not self:valid() then
    return
  end
  opts = opts or {}
  local mode = opts.mode or Util.mapmode()
  local ret = self.modes[mode]
  if not ret then
    self.modes[mode] = Mode.new(self, mode)
    return self.modes[mode]
  elseif opts.update then
    ret:update()
  end
  return ret
end

return M
