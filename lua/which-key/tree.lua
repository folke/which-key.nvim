local Config = require("which-key.config")
local Node = require("which-key.node")
local Util = require("which-key.util")

---@class wk.Tree
---@field root wk.Node
local M = {}
M.__index = M

---@type table<string, table<wk.Mapping|wk.Keymap, true>>
M.dups = {}

function M.new()
  local self = setmetatable({}, M)
  self:clear()
  return self
end

function M:clear()
  self.root = Node.new()
end

---@param keymap wk.Mapping|wk.Keymap
---@param virtual? boolean
function M:add(keymap, virtual)
  if not Config.filter(keymap) then
    return
  end
  local keys = Util.keys(keymap.lhs, { norm = true })
  local node = assert(self.root:find(keys, { create = true }))
  node.plugin = node.plugin or keymap.plugin
  if virtual then
    ---@cast node wk.Node
    if node.mapping and not keymap.preset and not node.mapping.preset then
      local id = keymap.mode .. ":" .. node.keys
      M.dups[id] = M.dups[id] or {}
      M.dups[id][keymap] = true
      M.dups[id][node.mapping] = true
    end
    if not (keymap.preset and node.keymap and node.keymap.desc) then
      node.mapping = keymap --[[@as wk.Mapping]]
    end
  else
    node.keymap = keymap
  end
end

---@param node wk.Node
function M:del(node)
  if node == self.root then
    return self:clear()
  end
  local parent = node.parent
  assert(parent, "node has no parent")
  parent._children[node.key] = nil
  if not self:keep(parent) then
    self:del(parent)
  end
end

---@param node wk.Node
function M:keep(node)
  if node.hidden or (node.keymap and node.keymap.desc == "which_key_ignore") then
    return false
  end
  return node.keymap or (node.mapping and not node.group) or node:is_group()
end

function M:fix()
  self:walk(function(node)
    if not self:keep(node) then
      self:del(node)
      return false
    end
  end)
end

---@param keys string|string[]
---@param opts? { create?: boolean, expand?: boolean }
---@return wk.Node?
function M:find(keys, opts)
  keys = type(keys) == "string" and Util.keys(keys) or keys
  return self.root:find(keys, opts)
end

---@param fn fun(node: wk.Node):boolean?
---@param opts? {expand?: boolean}
function M:walk(fn, opts)
  opts = opts or {}
  ---@type wk.Node[]
  local queue = { self.root }
  while #queue > 0 do
    local node = table.remove(queue, 1) ---@type wk.Node
    if node == self.root or fn(node) ~= false then
      local children = opts.expand and node:children() or node._children
      for _, child in pairs(children) do
        queue[#queue + 1] = child
      end
    end
  end
end

return M
