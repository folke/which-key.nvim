local Config = require("which-key.config")
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
  self.root = { key = "", path = {}, keys = "" }
end

---@param node wk.Node
function M.count(node)
  local children = node.children
  return vim.tbl_count(children or {})
end

---@param node wk.Node
function M.is_group(node)
  return M.count(node) > 0
end

---@param keymap wk.Mapping|wk.Keymap
---@param virtual? boolean
function M:add(keymap, virtual)
  assert(type(keymap.lhs) == "string", "input must be a string: " .. vim.inspect(keymap))
  if not Config.filter(keymap) then
    return
  end
  local keys = Util.keys(keymap.lhs, { norm = true })
  local node = self.root
  local path = {} ---@type string[]
  for _, key in ipairs(keys) do
    path[#path + 1] = key
    node.children = node.children or {}
    if not node.children[key] then
      node.children[key] = {
        key = key,
        keys = node.keys .. key,
        path = vim.deepcopy(path),
        parent = node,
        global = true,
      }
    end
    node = node.children[key]
  end

  node.desc = keymap.desc or node.desc
  node.plugin = node.plugin or keymap.plugin
  node.global = not (keymap.buffer and keymap.buffer ~= 0)
  if virtual then
    ---@cast node wk.Node
    if node.mapping and not keymap.preset and not node.mapping.preset then
      local id = keymap.mode .. ":" .. node.keys
      M.dups[id] = M.dups[id] or {}
      M.dups[id][keymap] = true
      M.dups[id][node.mapping] = true
    end
    node.mapping = keymap
  else
    node.keymap = keymap
  end
  -- node.keymap = not keymap.group and keymap or nil
  if node.plugin then
    setmetatable(node, require("which-key.plugins").PluginNode)
  end
end

---@param node wk.Node
function M:del(node)
  if node == self.root then
    return self:clear()
  end
  local parent = node.parent
  assert(parent, "node has no parent")
  parent.children[node.key] = nil
  if not self:keep(parent) then
    self:del(parent)
  end
end

---@param node wk.Node
function M:keep(node)
  if (node.keymap and node.keymap.desc == "which_key_ignore") or (node.mapping and node.mapping.hidden) then
    return false
  end
  return node.plugin or node.keymap or M.is_group(node) or (node.mapping and not node.mapping.group)
end

function M:fix()
  self:walk(function(node)
    if not self:keep(node) then
      self:del(node)
    end
  end)
end

---@param keys string|string[]
---@return wk.Node?
function M:find(keys)
  keys = type(keys) == "string" and Util.keys(keys) or keys
  ---@cast keys string[]
  local node = self.root
  for _, key in ipairs(keys) do
    node = (node.children or {})[key] ---@type wk.Node?
    if not node then
      return
    end
  end
  return node
end

---@param fn fun(node: wk.Node):boolean?
function M:walk(fn)
  ---@type wk.Node[]
  local queue = { self.root }
  while #queue > 0 do
    local node = table.remove(queue, 1) ---@type wk.Node
    if node == self.root or fn(node) ~= false and not node.plugin then
      for _, child in pairs(node.children or {}) do
        queue[#queue + 1] = child
      end
    end
  end
end

return M
