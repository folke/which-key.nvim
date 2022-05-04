local Util = require("which-key.util")

---@class Tree
---@field root Node
local Tree = {}
Tree.__index = Tree

---@class Node
---@field mapping Mapping
---@field prefix_i string
---@field prefix_n string
---@field children table<string, Node>
-- selene: allow(unused_variable)
local Node

---@return Tree
function Tree:new()
  local this = { root = { children = {}, prefix_i = "", prefix_n = "" } }
  setmetatable(this, self)
  return this
end

---@param prefix_i string
---@param index number defaults to last. If < 0, then offset from last
---@return Node
function Tree:get(prefix_i, index, plugin_context)
  prefix_i = Util.parse_internal(prefix_i)
  local node = self.root
  index = index or #prefix_i
  if index < 0 then
    index = #prefix_i + index
  end
  for i = 1, index, 1 do
    node = node.children[prefix_i[i]]
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
---@param prefix_i string
---@return Node[]
function Tree:path(prefix_i)
  prefix_i = Util.parse_internal(prefix_i)
  local node = self.root
  local path = {}
  for i = 1, #prefix_i, 1 do
    node = node.children[prefix_i[i]]
    table.insert(path, node)
    if not node then
      break
    end
  end
  return path
end

---@param mapping Mapping
function Tree:add(mapping)
  local prefix_i = mapping.keys.internal
  local prefix_n = mapping.keys.notation
  local node = self.root
  local path_i = ""
  local path_n = ""
  for i = 1, #prefix_i, 1 do
    path_i = path_i .. prefix_i[i]
    path_n = path_n .. prefix_n[i]
    if not node.children[prefix_i[i]] then
      node.children[prefix_i[i]] = { children = {}, prefix_i = path_i, prefix_n = path_n }
    end
    node = node.children[prefix_i[i]]
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
