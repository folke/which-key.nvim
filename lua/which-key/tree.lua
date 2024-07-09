local Util = require("which-key.util")

---@class wk.Node
---@field key string
---@field path string[]
---@field parent? wk.Node
---@field desc? string
---@field keymap? wk.Keymap
---@field children? table<string, wk.Node>

---@class wk.Tree
---@field root wk.Node
local M = {}
M.__index = M

function M.new()
  local self = setmetatable({}, M)
  self:clear()
  return self
end

function M:clear()
  self.root = { key = "", path = {} }
end

---@param keymap wk.Keymap
function M:_add(keymap)
  local keys = Util.keys(keymap.lhs, { norm = true })
  local node = self.root
  local path = {} ---@type string[]
  for _, key in ipairs(keys) do
    path[#path + 1] = key
    node.children = node.children or {}
    if not node.children[key] then
      node.children[key] = {
        key = key,
        path = vim.deepcopy(path),
        parent = node,
      }
    end
    node = node.children[key]
  end
  node.desc = keymap.desc
  if not keymap.group then
    node.keymap = keymap
  end
end

---@param keymaps wk.Keymap[]
function M:add(keymaps)
  for _, keymap in ipairs(keymaps) do
    if keymap.lhs:sub(1, 6) ~= "<Plug>" then
      self:_add(keymap)
    end
  end
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
    if node == self.root or fn(node) ~= false then
      for _, child in pairs(node.children or {}) do
        queue[#queue + 1] = child
      end
    end
  end
end

return M
