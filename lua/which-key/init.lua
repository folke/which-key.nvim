local M = {}

function M.show(keys, opts) end

---@type {mappings:table, opts?:table}
M._queue = {}

function M.register(mappings, opts)
  table.insert(M._queue, { mappings = mappings, opts = opts })
end

function M.setup(opts)
  require("which-key.config").setup(opts)
end

return M
