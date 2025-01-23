local Util = require("which-key.util")

---@class wk.Node
---@field _children table<string, wk.Node>
local M = {}

---@param parent? wk.Node
---@param key? string
---@return wk.Node
function M.new(parent, key)
  local self = setmetatable({}, M)
  self.parent = parent
  self.key = key or ""
  self.path = {}
  self.global = true
  self._children = {}
  self.keys = (parent and parent.keys or "") .. self.key
  for _, p in ipairs(parent and parent.path or {}) do
    table.insert(self.path, p)
  end
  if key then
    table.insert(self.path, key)
  end
  return self
end

function M:has_nowait_ancestor()
  local node = self
  while node do
    if node.keymap and node.keymap.nowait then
      return true
    end
    node = node.parent
  end
  return false
end

function M:is_local()
  if self.path[1] == Util.norm("<localleader>") then
    return true
  end
  if self.buffer and self.buffer > 0 then
    return true
  end
  for _, child in pairs(self._children) do
    if child:is_local() then
      return true
    end
  end
  return false
end

function M:__index(k)
  if k == "mapping" or k == "keymap" then
    return
  end
  local v = rawget(M, k)
  if v ~= nil then
    return v
  end
  for _, m in ipairs({ "mapping", "keymap" }) do
    local mm = rawget(self, m)
    if k == m then
      return mm
    end
    if mm and mm[k] ~= nil then
      return mm[k]
    end
  end
end

function M:__tostring()
  local info = { "Node(" .. self.keys .. ")" }
  if self:is_plugin() then
    info[#info + 1] = "Plugin(" .. self.plugin .. ")"
  end
  if self:is_proxy() then
    info[#info + 1] = "Proxy(" .. self.mapping.proxy .. ")"
  end
  return table.concat(info, " ")
end

---@param depth? number
function M:inspect(depth)
  local indent = ("  "):rep(depth or 0)
  local ret = { indent .. tostring(self) }
  for _, child in ipairs(self:children()) do
    table.insert(ret, child:inspect((depth or 0) + 1))
  end
  return table.concat(ret, "\n")
end

function M:count()
  return not self:can_expand() and vim.tbl_count(self._children) or #self:children()
end

function M:is_group()
  return self:can_expand() or self:count() > 0
end

function M:is_proxy()
  return self.mapping and self.mapping.proxy
end

function M:is_plugin()
  return self.plugin ~= nil
end

function M:can_expand()
  return self.plugin or (self.mapping and (self.mapping.proxy or self.mapping.expand))
end

---@return wk.Node[]
function M:children()
  return vim.tbl_values(self:expand())
end

---@return table<string, wk.Node>
function M:expand()
  if not self:can_expand() then
    return self._children
  end

  ---@type table<string, wk.Node>
  local ret = {}

  -- plugin mappings
  if self.plugin then
    local plugin = require("which-key.plugins").plugins[self.plugin or ""]
    assert(plugin, "plugin not found")
    Util.debug(("Plugin(%q).expand"):format(self.plugin))

    for i, item in ipairs(plugin.expand()) do
      item.order = i
      local child = M.new(self, item.key) --[[@as wk.Node.plugin.item]]
      setmetatable(child, { __index = setmetatable(item, M) })
      ret[item.key] = child
    end
  end

  -- proxy mappings
  local proxy = self.mapping.proxy
  if proxy then
    local keys = Util.keys(proxy)
    local root = self:root()
    local node = root:find(keys, { expand = true })
    if node then
      for k, v in pairs(node:expand()) do
        ret[k] = v
      end
    end
  end

  -- expand mappings
  local expand = self.mapping and self.mapping.expand
  if expand then
    local Tree = require("which-key.tree")
    local tmp = Tree.new()
    local mappings = require("which-key.mappings").parse(expand())
    for _, mapping in ipairs(mappings) do
      tmp:add(mapping, true)
    end
    for _, child in ipairs(tmp.root:children()) do
      local action = child.mapping and child.mapping.rhs
      if type(action) == "function" then
        child.action = action
      elseif type(action) == "string" then
        Util.error("expand mappings only support functions as rhs:\n" .. vim.inspect(child.mapping))
      end
      ret[child.key] = child
    end
  end

  -- custom mappings
  for k, v in pairs(self._children) do
    ret[k] = v
  end

  return ret
end

function M:root()
  local node = self
  while node.parent do
    node = node.parent
  end
  return node
end

---@param path string[]|string
---@param opts? { create?: boolean, expand?: boolean }
---@return wk.Node?
function M:find(path, opts)
  path = (type(path) == "string" and { path } or path) --[[@as string[] ]]
  opts = opts or {}
  local node = self
  for _, key in ipairs(path) do
    local child ---@type wk.Node?
    if opts.expand then
      child = node:expand()[key]
    else
      child = node._children[key]
    end
    if not child then
      if not opts.create then
        return
      end
      child = M.new(node, key)
      node._children[key] = child
    end
    node = child
  end
  return node
end

return M
