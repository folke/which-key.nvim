local Util = require("which-key.util")

---@class wk.Node
---@field key string
---@field desc? string
---@field keymap? Keymap
---@field children? table<string, wk.Node>

---@alias wk.Path {node:wk.Node, keys:string[]}

---@class wk.Tree
---@field root wk.Node
local M = {}
M.__index = M

function M.new()
  local self = setmetatable({}, M)
  self.root = { key = "" }
  return self
end

---@param keymap Keymap
function M:_add(keymap)
  local keys = Util.keys(keymap.lhs, { norm = true })
  local node = self.root
  for _, key in ipairs(keys) do
    node.children = node.children or {}
    node.children[key] = node.children[key] or { key = key }
    node = node.children[key]
  end
  node.desc = keymap.desc
  if not keymap.group then
    node.keymap = keymap
  end
end

---@param keymaps Keymap[]
function M:add(keymaps)
  for _, keymap in ipairs(keymaps) do
    if keymap.lhs:sub(1, 6) ~= "<Plug>" then
      self:_add(keymap)
    end
  end
end

---@param keys string|string[]
---@return wk.Path?
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
  return { node = node, keys = keys }
end

---@param fn fun(path: wk.Path):boolean?
function M:walk(fn)
  ---@type wk.Path[]
  local queue = {
    { node = self.root, keys = {} },
  }
  while #queue > 0 do
    local path = table.remove(queue, 1) ---@type wk.Path
    if path.node == self.root or fn(path) ~= false then
      for _, child in pairs(path.node.children or {}) do
        local keys = {} ---@type string[]
        vim.list_extend(keys, path.keys)
        keys[#keys + 1] = child.key
        queue[#queue + 1] = {
          node = child,
          keys = keys,
        }
      end
    end
  end
end

return M
