local Tree = require("which-key.tree")
local Util = require("which-key.util")

---@alias wk.BufferMode {mode:string, tree:wk.Tree, triggers:table<string,string>}
---@class wk.Buffer
---@field buf number
---@field modes table<string, wk.BufferMode>
local M = {}
M.__index = M
M.attached = {} ---@type table<number,wk.Buffer>

function M.attach(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  if vim.bo[buf].buftype == "nofile" then
    return
  end
  local ret = M.attached[buf]
  if not ret then
    ret = M.new(buf)
    M.attached[buf] = ret
  end
  return ret
end

---@param buf number
function M.new(buf)
  local self = setmetatable({}, M)
  self.buf = buf
  self.modes = {}

  -- self.update = Util.debounce(300, function()
  --   M.update(self)
  -- end)
  return self
end

---@param mode? string
function M:clear(mode)
  local modes = mode and { mode } or vim.tbl_keys(self.modes)
  for _, m in ipairs(modes) do
    if self.modes[m] then
      for trigger in pairs(self.modes[m].triggers) do
        pcall(vim.keymap.del, m, trigger, { buffer = self.buf })
      end
      self.modes[m].triggers = {}
    end
    self.modes[m] = nil
  end
end

function M:valid()
  return vim.api.nvim_buf_is_valid(self.buf)
end

function M:update()
  local mode = Util.mapmode()
  self:clear(mode)
  return self:get(mode)
end

---@param mode string
---@return wk.BufferMode?
function M:get(mode)
  if not self:valid() then
    return
  end
  if self.modes[mode] then
    return self.modes[mode]
  end
  ---@type wk.BufferMode
  local ret = { mode = mode, tree = Tree.new(), triggers = {} }
  self.modes[mode] = ret

  local mappings = vim.api.nvim_get_keymap(mode)
  vim.list_extend(mappings, vim.api.nvim_buf_get_keymap(self.buf, mode))

  mappings = vim.tbl_filter(function(mapping)
    if (mapping.rhs == "" or mapping.rhs == "<Nop>") and mapping.desc then
      require("which-key").register({
        [mapping.lhs] = {
          mapping.desc,
          mode = mode,
          group = true,
          buffer = mapping.buffer,
        },
      })
      pcall(vim.keymap.del, mode, mapping.lhs, { buffer = mapping.buffer })
      return false
    end
    return not self:is_trigger(mode, mapping.lhs)
  end, mappings)

  for _, m in ipairs(require("which-key").mappings) do
    if m.mode == mode and (not m.buffer or m.buffer == self.buf) then
      table.insert(mappings, m)
    end
  end

  ret.tree:add(mappings --[[@as Keymap[] ]])

  self:_triggers(ret)
  -- dd(ret.triggers)
  return ret
end

---@param mode wk.BufferMode
function M:_triggers(mode)
  if mode.mode:find("[xo]") then
    return
  end
  mode.tree:walk(function(path)
    if not path.node.keymap and path.node.children then
      self:add_trigger(mode, path)
      return false
    end
  end)
end

---@param mode string
---@param lhs string
function M:is_trigger(mode, lhs)
  return self.modes[mode] and self.modes[mode].triggers[lhs]
end

---@param mode wk.BufferMode
---@param path wk.Path
function M:on_trigger(mode, path)
  require("which-key.state").set(path, "on_trigger")
  local lhs = table.concat(path.keys)
  local node = path.node
  local keys = vim.deepcopy(path.keys)
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
      self:del_trigger(mode, lhs)
      vim.schedule(function()
        self:add_trigger(mode, path)
      end)
      local keystr = table.concat(keys)
      local feed = vim.api.nvim_replace_termcodes("<Ignore>" .. keystr, true, true, true)
      vim.api.nvim_feedkeys(feed, "mit", false)
      break
    else
      require("which-key.state").set({ node = node, keys = keys }, "on_trigger")
    end
  end
end

---@param mode wk.BufferMode
---@param path wk.Path
function M:add_trigger(mode, path)
  local lhs = table.concat(path.keys)
  mode.triggers[lhs] = lhs
  vim.keymap.set(mode.mode, lhs, function()
    self:on_trigger(mode, path)
  end, { buffer = self.buf, nowait = true })
  return lhs
end

---@param mode wk.BufferMode
function M:del_trigger(mode, lhs)
  mode.triggers[lhs] = nil
  pcall(vim.keymap.del, mode.mode, lhs, { buffer = self.buf })
end

return M
