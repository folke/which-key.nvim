---@class wk
---@field private _queue {spec: wk.Spec, opts?: wk.Parse}[]
local M = {}

M._queue = {}
M.did_setup = false

--- Open which-key
---@param opts? wk.Filter|string
function M.show(opts)
  opts = opts or {}
  opts = type(opts) == "string" and { keys = opts } or opts
  if opts.delay == nil then
    opts.delay = 0
  end
  opts.waited = vim.o.timeoutlen
  ---@diagnostic disable-next-line: param-type-mismatch
  if not require("which-key.state").start(opts) then
    require("which-key.util").warn(
      "No mappings found for mode `" .. (opts.mode or "n") .. "` and keys `" .. (opts.keys or "") .. "`"
    )
  end
end

---@param opts? wk.Opts
function M.setup(opts)
  M.did_setup = true
  require("which-key.config").setup(opts)
end

-- Use `require("which-key").add()` instead.
-- The spec is different though, so check the docs!
---@deprecated
---@param mappings wk.Spec
---@param opts? wk.Mapping
function M.register(mappings, opts)
  if opts then
    for k, v in pairs(opts) do
      mappings[k] = v
    end
  end
  M.add(mappings, { version = 1 })
end

--- Add mappings to which-key
---@param mappings wk.Spec
---@param opts? wk.Parse
function M.add(mappings, opts)
  table.insert(M._queue, { spec = mappings, opts = opts })
end

return M
