local M = {}

---@param filter? wk.Filter|string
function M.show(filter)
  ---@diagnostic disable-next-line: param-type-mismatch
  require("which-key.state").start(type(filter) == "string" and { keys = filter } or filter)
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
