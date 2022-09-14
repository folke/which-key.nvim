local Keys = require("which-key.keys")
local Util = require("which-key.util")

---@class WhichKey
local M = {}

local loaded = false -- once we loaded everything
local scheduled = false

local function schedule_load()
  if scheduled then
    return
  end
  scheduled = true
  if vim.v.vim_did_enter == 0 then
    vim.cmd([[au VimEnter * ++once lua require("which-key").load()]])
  else
    M.load()
  end
end

---@param options? Options
function M.setup(options)
  require("which-key.config").setup(options)
  schedule_load()
end

function M.execute(id)
  local func = Keys.functions[id]
  return func()
end

function M.show(keys, opts)
  opts = opts or {}
  if type(opts) == "string" then
    opts = { mode = opts }
  end

  keys = keys or ""

  opts.mode = opts.mode or Util.get_mode()
  local buf = vim.api.nvim_get_current_buf()
  -- make sure the trees exist for update
  Keys.get_tree(opts.mode)
  Keys.get_tree(opts.mode, buf)
  -- update only trees related to buf
  Keys.update(buf)
  -- trigger which key
  require("which-key.view").open(keys, opts)
end

function M.show_command(keys, mode)
  keys = keys or ""
  keys = (keys == '""' or keys == "''") and "" or keys
  mode = (mode == '""' or mode == "''") and "" or mode
  mode = mode or "n"
  keys = Util.t(keys)
  if not Util.check_mode(mode) then
    Util.error(
      "Invalid mode passed to :WhichKey (Don't create any keymappings to trigger WhichKey. WhichKey does this automatically)"
    )
  else
    M.show(keys, { mode = mode })
  end
end

local queue = {}

-- Defer registering keymaps until VimEnter
function M.register(mappings, opts)
  schedule_load()
  if loaded then
    Keys.register(mappings, opts)
    Keys.update()
  else
    table.insert(queue, { mappings, opts })
  end
end

-- Load mappings and update only once
function M.load()
  if loaded then
    return
  end
  require("which-key.plugins").setup()
  require("which-key.colors").setup()
  Keys.register({}, { prefix = "<leader>", mode = "n" })
  Keys.register({}, { prefix = "<leader>", mode = "v" })
  Keys.setup()

  for _, reg in pairs(queue) do
    local opts = reg[2] or {}
    opts.update = false
    Keys.register(reg[1], opts)
  end
  Keys.update()
  queue = {}
  loaded = true
end

function M.reset()
  -- local mappings = Keys.mappings
  require("plenary.reload").reload_module("which-key")
  -- require("which-key.Keys").mappings = mappings
  require("which-key").setup()
end

return M
