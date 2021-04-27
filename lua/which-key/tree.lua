local Util = require("which-key.util")

---@class Tree
---@field root Node
local Tree = {}
Tree.__index = Tree

---@class Node
---@field mapping Mapping
---@field prefix string
---@field children table<string, Node>
local Node

---@return Tree
function Tree:new()
  local this = { root = { children = {}, prefix = "" } }
  setmetatable(this, self)
  return this
end

---@param prefix string
---@return Node
function Tree:get(prefix, offset)
  offset = offset or 0
  prefix = Util.parse_keys(prefix).term
  local node = self.root
  for i = 1, #prefix - offset, 1 do
    node = node.children[prefix[i]]
    if not node then return nil end
  end
  return node
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
  for _, child in pairs(node.children) do self:walk(cb, child) end
end

return Tree
