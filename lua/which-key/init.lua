local M = {}

---@param lhs? string
---@param opts? {buf?: number, mode?:string, update?:boolean}
function M.show(lhs, opts)
  opts = opts or {}
  if opts.update == nil then
    opts.update = true
  end
  local Buf = require("which-key.buf")
  local State = require("which-key.state")
  local mode = Buf.get(opts)
  if not mode then
    return
  end
  local node = mode.tree:find(lhs or {})
  if node then
    State.start(node)
  end
end

---@type {mappings:table, opts?:table}
M._queue = {}

function M.register(mappings, opts)
  table.insert(M._queue, { mappings = mappings, opts = opts })
end

function M.setup(opts)
  require("which-key.config").setup(opts)
end

return M
