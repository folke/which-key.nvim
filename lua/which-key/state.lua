local Buf = require("which-key.buf")

local M = {}

---@class wk.State
---@field buf? number
---@field node? wk.Node
---@field debug? string
M.state = {}

function M.setup()
  local group = vim.api.nvim_create_augroup("wk", { clear = true })

  local in_op = false
  vim.on_key(function(_, key)
    if not key then
      return
    end
    if in_op and key:find("\27") then
      in_op = false
      M.set()
    end
  end)

  vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    callback = function(ev)
      local mode = Buf.get({ buf = ev.buf, update = true })
      if mode then
        if mode.mode:find("[xo]") then
          M.set(mode.tree.root, "mode_1")
          local char = vim.fn.getcharstr()
          M.set(mode.tree:find(char), "mode_2")
          in_op = true
          vim.api.nvim_feedkeys(char, "mit", false)
          return
        end
      end
      M.set()
    end,
  })

  vim.api.nvim_create_autocmd({ "BufReadPost", "LspAttach" }, {
    group = group,
    callback = function(ev)
      Buf.get({ buf = ev.buf, update = true })
    end,
  })

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    Buf.get({ buf = buf, update = true })
  end
end

---@param node? wk.Node
---@param debug? string
function M.set(node, debug)
  if not node then
    M.state = {}
    require("which-key.view").hide()
    return
  end
  M.state.buf = vim.api.nvim_get_current_buf()
  M.state.node = node
  M.state.debug = debug
  require("which-key.view").show()
end

---@return wk.State?
function M.get()
  if M.state.buf and M.state.buf == vim.api.nvim_get_current_buf() then
    return M.state
  end
  M.state = {}
end

return M
