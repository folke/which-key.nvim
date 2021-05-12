local Util = require("which-key.util")

---@class Tree
---@field root Node
local Tree = {}
Tree.__index = Tree

---@class Node
---@field mapping Mapping
---@field prefix string
---@field children table<string, Node>
-- selene: allow(unused_variable)
local Node

---@return Tree
function Tree:new()
  local this = { root = { children = {}, prefix = "" } }
  setmetatable(this, self)
  return this
end

---@param prefix string
---@param index number defaults to last. If < 0, then offset from last
---@return Node
function Tree:get(prefix, index, plugin_context)
  prefix = Util.parse_keys(prefix).term
  local node = self.root
  index = index or #prefix
  if index < 0 then
    index = #prefix + index
  end
  for i = 1, index, 1 do
    node = node.children[prefix[i]]
    if node and plugin_context and node.mapping and node.mapping.plugin then
      local children = require("which-key.plugins").invoke(node.mapping, plugin_context)
      node.children = {}
      for _, child in pairs(children) do
        self:add(child)
      end
    end
    if not node then
      return nil
    end
  end
  return node
end

-- Returns the path (possibly incomplete) for the prefix
---@param prefix string
---@return Node[]
function Tree:path(prefix)
  prefix = Util.parse_keys(prefix).term
  local node = self.root
  local path = {}
  for i = 1, #prefix, 1 do
    node = node.children[prefix[i]]
    table.insert(path, node)
    if not node then
      break
    end
  end
  return path
end

---@param mapping Mapping
function Tree:add(mapping)
  local prefix = mapping.keys.term
  local node = self.root
  local path = ""
  for i = 1, #prefix, 1 do
    path = path .. prefix[i]
    if not node.children[prefix[i]] then
      node.children[prefix[i]] = { children = {}, prefix = path }
    end
    node = node.children[prefix[i]]
  end
  node.mapping = vim.tbl_deep_extend("force", node.mapping or {}, mapping)
end

---@param cb fun(node:Node)
---@param node Node
function Tree:walk(cb, node)
  node = node or self.root
  cb(node)
  for _, child in pairs(node.children) do
    self:walk(cb, child)
  end
end

return Tree
