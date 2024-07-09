local Tree = require("which-key.tree")
local Util = require("which-key.util")

---@class wk.Mode
---@field buf wk.Buffer
---@field mode string
---@field tree wk.Tree
---@field triggers table<string, wk.Node>
local Mode = {}
Mode.__index = Mode

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
  -- FIXME:
  if self.mode:find("[xo]") then
    return
  end
  self.tree:walk(function(node)
    if not node.keymap and node.children then
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
function Mode:_attach(node)
  local lhs = table.concat(node.path)
  self.triggers[lhs] = node
  vim.keymap.set(self.mode, lhs, function()
    self:on_trigger(node)
  end, { buffer = self.buf.buf, nowait = true })
  return lhs
end

---@param node wk.Node
function Mode:_detach(node)
  local lhs = table.concat(node.path)
  self.triggers[lhs] = nil
  pcall(vim.keymap.del, self.mode, lhs, { buffer = self.buf.buf })
end

---@param node wk.Node
function Mode:on_trigger(node)
  local trigger_node = node
  require("which-key.state").set(node, "on_trigger")
  local lhs = table.concat(node.path)
  local keys = vim.deepcopy(node.path)
  while true do
    local key = vim.fn.keytrans(vim.fn.getcharstr())
    if key == "<Esc>" then
      require("which-key.state").set()
      break
    end
    keys[#keys + 1] = key

    node = (node.children or {})[key] ---@type wk.Node?

    if not node or node.keymap then
      require("which-key.state").set()
      self:_detach(trigger_node)
      vim.schedule(function()
        self:_attach(trigger_node)
      end)
      local keystr = table.concat(keys)
      local feed = vim.api.nvim_replace_termcodes("<Ignore>" .. keystr, true, true, true)
      vim.api.nvim_feedkeys(feed, "mit", false)
      break
    else
      require("which-key.state").set(node, "on_trigger")
    end
  end
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

  ---@param mapping wk.Keymap
  mappings = vim.tbl_filter(function(mapping)
    if (mapping.rhs == "" or mapping.rhs == "<Nop>") and mapping.desc then
      if mapping.buffer == 0 then
        mapping.buffer = nil
      end
      require("which-key").register({
        [mapping.lhs] = {
          mapping.desc,
          mode = self.mode,
          group = true,
          buffer = mapping.buffer,
        },
      })
      pcall(vim.keymap.del, self.mode, mapping.lhs, { buffer = mapping.buffer })
      return false
    end
    return not self:is_trigger(mapping.lhs)
  end, mappings)

  for _, m in ipairs(require("which-key").mappings) do
    if m.mode == self.mode and (not m.buffer or m.buffer == self.buf) then
      table.insert(mappings, m)
    end
  end

  self.tree:add(mappings --[[@as wk.Keymap[] ]])
  self:attach()
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

---@param buf number
function Buf.new(buf)
  local self = setmetatable({}, Buf)
  self.buf = buf
  self.modes = {}
  -- self.update = Util.debounce(300, function()
  --   M.update(self)
  -- end)
  return self
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
