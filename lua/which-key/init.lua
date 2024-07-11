local M = {}

---@param opts? wk.Filter|string
function M.show(opts)
  opts = opts or {}
  opts = type(opts) == "string" and { keys = opts } or opts
  opts.delay = 0
  ---@diagnostic disable-next-line: param-type-mismatch
  require("which-key.state").start(opts)
end

---@type {spec:wk.Spec, opts?:wk.Mapping}[]
M._queue = {}

---@param mappings wk.Spec
---@param opts? wk.Mapping
function M.register(mappings, opts)
  table.insert(M._queue, { spec = mappings, opts = opts })
end

function M.setup(opts)
  require("which-key.config").setup(opts)
end

return M
