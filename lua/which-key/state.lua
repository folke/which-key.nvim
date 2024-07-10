local Buf = require("which-key.buf")
local Tree = require("which-key.tree")
local Util = require("which-key.util")

local M = {}

---@class wk.State
---@field mode wk.Mode
---@field node wk.Node

---@type wk.State?
M.state = nil

function M.setup()
  local group = vim.api.nvim_create_augroup("wk", { clear = true })

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    callback = function()
      M.stop()
    end,
  })

  vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    callback = function()
      if Util.xo() then
        return not M.state and M.start()
      else
        M.stop()
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "BufReadPost", "LspAttach", "LspDetach" }, {
    group = group,
    callback = function(ev)
      Buf.get({ buf = ev.buf, update = true })
    end,
  })

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    Buf.get({ buf = buf, update = true })
  end
end

function M.stop()
  M.state = nil
  vim.schedule(function()
    if not M.state then
      require("which-key.view").hide()
    end
  end)
end

---@param state wk.State
---@return wk.Node?
function M.step(state)
  vim.cmd.redraw()
  local key = vim.fn.keytrans(vim.fn.getcharstr())
  local node = (state.node.children or {})[key] ---@type wk.Node?

  local mode = state.mode.mode
  local xo = mode:find("[xo]") ~= nil

  if node then
    local is_group = Tree.is_group(node)
    local is_nowait = node.keymap and node.keymap.nowait == 1
    local is_action = node.action ~= nil
    local is_keymap = node.keymap ~= nil
    if is_group and not is_nowait and not is_action then
      return node
    end
  elseif key == "<Esc>" then
    -- cancel and exit if in op-mode
    return mode == "o" and Util.exit() or nil
  elseif key == "<BS>" then
    return state.node.parent or state.mode.tree.root
  end

  state.mode:reattach(node or state.node)

  if node and node.action then
    return node.action()
  end

  local keys = vim.deepcopy(state.node.path)
  keys[#keys + 1] = key

  local keystr = table.concat(keys)
  if not xo then
    if vim.v.count > 0 then
      keystr = vim.v.count .. keystr
    end
    if vim.v.register ~= Util.reg() and mode ~= "i" and mode ~= "c" then
      keystr = '"' .. vim.v.register .. keystr
    end
  end
  local feed = vim.api.nvim_replace_termcodes(keystr, true, true, true)
  vim.api.nvim_feedkeys(feed, "mit", false)
end

---@param node? wk.Node
function M.start(node)
  local mode = Buf.get({ update = true })
  if not mode then
    return
  end

  local View = require("which-key.view")

  M.state = {
    mode = mode,
    node = node or mode.tree.root,
  }

  while M.state and Buf.get() == mode do
    View.update()
    local child = M.step(M.state)
    if child and M.state then
      M.state.node = child
    else
      break
    end
  end
  M.state = nil
  View.hide()
end

function M.update()
  if not M.state then
    return
  end
  local mode = Buf.get()
  if not mode or mode ~= M.state.mode then
    return M.stop()
  end
  local node = mode.tree:find(M.state.node.path)
  if not node then
    return M.stop()
  end
  M.state.node = node
  require("which-key.view").update()
end

return M
