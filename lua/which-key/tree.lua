local Util = require("which-key.util")

---@class Tree
---@field root Node
---@field nodes table<string, Node>
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
  local this = { root = { children = {}, prefix_i = "", prefix_n = "" }, nodes = {} }
  setmetatable(this, self)
  return this
end

---@param prefix_i string
---@param index? number defaults to last. If < 0, then offset from last
---@param plugin_context? any
---@return Node?
function Tree:get(prefix_i, index, plugin_context)
  local prefix = Util.parse_internal(prefix_i)
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
        self:add(child, { cache = false })
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
  local prefix = Util.parse_internal(prefix_i)
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
---@param opts? {cache?: boolean}
---@return Node
function Tree:add(mapping, opts)
  opts = opts or {}
  opts.cache = opts.cache ~= false
  local node_key = mapping.keys.keys
  local node = opts.cache and self.nodes[node_key]
  if not node then
    local prefix_i = mapping.keys.internal
    local prefix_n = mapping.keys.notation
    node = self.root
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
    if opts.cache then
      self.nodes[node_key] = node
    end
  end
  node.mapping = vim.tbl_deep_extend("force", node.mapping or {}, mapping)
  return node
end

---@param cb fun(node:Node)
---@param node? Node
function Tree:walk(cb, node)
  node = node or self.root
  cb(node)
  for _, child in pairs(node.children) do
    self:walk(cb, child)
  end
end

return Tree
