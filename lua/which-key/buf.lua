local Config = require("which-key.config")
local Tree = require("which-key.tree")
local Triggers = require("which-key.triggers")
local Util = require("which-key.util")

---@class wk.Mode
---@field buf wk.Buffer
---@field mode string
---@field tree wk.Tree
---@field triggers wk.Node[]
local Mode = {}
Mode.__index = Mode

---@param node wk.Node
local function is_special(node)
  return (node:is_plugin() or node:is_proxy()) and not node.keymap
end

--- Checks if it's safe to add a trigger for the given node
---@param node wk.Node
---@param no_single? boolean
local function is_safe(node, no_single)
  if node.keymap or is_special(node) or node:count() == 0 then
    return false
  end
  if no_single and #node.path == 1 then
    local key = node.path[1]
    -- only z or g are safe
    if key:match("^[a-z]$") and not key:match("^[gz]$") then
      return false
    end
    -- only Z is safe
    if key:match("^[A-Z]$") and not key:match("^[Z]$") then
      return false
    end
  end
  return true
end

function Mode:__tostring()
  return string.format("Mode(%s:%d)", self.mode, self.buf.buf)
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
  self.triggers = {}

  -- NOTE: order is important for nowait to work!
  -- * first add plugin mappings
  -- * then add triggers
  self.tree:walk(function(node)
    if is_special(node) then
      table.insert(self.triggers, node)
      return false
    end
  end)

  if Config.triggers.modes[self.mode] then
    -- Auto triggers
    self.tree:walk(function(node)
      if is_safe(node, true) then
        table.insert(self.triggers, node)
        return false
      end
    end)
  end

  -- Manual triggers
  for _, t in ipairs(Config.triggers.mappings) do
    if self:has(t) then
      local node = self.tree:find(t.lhs)
      if node and is_safe(node) then
        table.insert(self.triggers, node)
      end
    end
  end

  Triggers.schedule(self)
end

function Mode:xo()
  return self.mode:find("[xo]") ~= nil
end

function Mode:clear()
  Triggers.detach(self)
  self.tree:clear()
end

---@param mode string
function Mode:is(mode)
  if mode == "v" then
    return self.mode == "x" or self.mode == "s"
  end
  return self.mode == mode
end

---@param mapping wk.Keymap
function Mode:has(mapping)
  return self:is(mapping.mode) and (not mapping.buffer or mapping.buffer == self.buf.buf)
end

function Mode:update()
  self.tree:clear()

  local mappings = vim.api.nvim_get_keymap(self.mode)
  vim.list_extend(mappings, vim.api.nvim_buf_get_keymap(self.buf.buf, self.mode))
  ---@cast mappings wk.Keymap[]

  for _, mapping in ipairs(mappings) do
    if mapping.desc and mapping.desc:find("which-key-trigger", 1, true) then
      -- ignore which-key triggers
    elseif Util.is_nop(mapping.rhs) then
      self.tree:add(mapping, true)
    elseif mapping.lhs:sub(1, 6) ~= "<Plug>" and mapping.lhs:sub(1, 5) ~= "<SNR>" then
      self.tree:add(mapping)
    end
  end

  for _, m in ipairs(Config.mappings) do
    if self:has(m) then
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
  local ret = self.modes[mode]
  if not ret then
    self.modes[mode] = Mode.new(self, mode)
    Util.debug("new " .. tostring(self.modes[mode]))
    return self.modes[mode]
  elseif opts.update then
    Util.debug("update " .. tostring(ret))
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
end

return M
