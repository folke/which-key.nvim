local Buf = require("which-key.buf")
local Config = require("which-key.config")
local Triggers = require("which-key.triggers")
local Util = require("which-key.util")

local uv = vim.uv or vim.loop

local M = {}

---@class wk.State
---@field mode wk.Mode
---@field node wk.Node
---@field filter wk.Filter
---@field started number
---@field show boolean

---@type wk.State?
M.state = nil
M.recursion = 0
M.recursion_timer = uv.new_timer()
M.redraw_timer = uv.new_timer()

---@return boolean safe, string? reason
function M.safe(mode_change)
  local old, _new = unpack(vim.split(mode_change, ":", { plain = true }))
  if old == "c" then
    return false, "command-mode"
  elseif Util.in_macro() then
    return false, "macro"
  elseif mode_change:lower() == "v:v" then
    return false, "visual-block"
  end
  local pending = vim.fn.getcharstr(1)
  if pending ~= "" then
    return false, "pending " .. ("%q"):format(vim.fn.strtrans(pending))
  end
  return true
end

function M.setup()
  local group = vim.api.nvim_create_augroup("wk", { clear = true })

  if Config.debug then
    vim.on_key(function(_raw, key)
      if key and #key > 0 then
        key = vim.fn.keytrans(key)
        if not key:find("ScrollWheel") and not key:find("Mouse") then
          Util.debug("on_key", key)
        end
      end
    end)
  end

  vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
    group = group,
    callback = function(ev)
      Util.debug(ev.event)
      if ev.event == "RecordingEnter" then
        Buf.clear({ buf = ev.buf })
        M.stop()
      end
    end,
  })

  local hide = uv.new_timer()
  vim.api.nvim_create_autocmd({ "FocusLost", "FocusGained" }, {
    group = group,
    callback = function(ev)
      if ev.event == "FocusGained" then
        hide:stop()
      elseif M.state then
        hide:start(5000, 0, function()
          vim.api.nvim_input("<esc>")
        end)
      end
    end,
  })

  local function defer()
    local mode = vim.api.nvim_get_mode().mode
    local mode_keys = Util.keys(mode)
    local ctx = {
      operator = mode:find("o") and vim.v.operator or nil,
      mode = mode_keys[1],
    }
    return Config.defer(ctx)
  end

  local cooldown = Util.cooldown()
  -- this prevents restarting which-key in the same tick
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    callback = function(ev)
      Util.trace("ModeChanged(" .. ev.match .. ")")
      local mode = Buf.get()

      if cooldown() then
        Util.debug("cooldown")
        Util.trace()
        return
      end

      local safe, reason = M.safe(ev.match)
      Util.debug(safe and "Safe(true)" or ("Unsafe(" .. reason .. ")"))
      if not safe then
        if mode then
          Triggers.suspend(mode)
        end
        -- dont start when recording or when chars are pending
        cooldown(true) -- cooldown till next tick
        M.stop()
        -- make sure the buffer mode exists
      elseif mode and Util.xo() then
        if Config.triggers.modes[mode.mode] and not M.state then
          M.start({ defer = defer() })
        end
      elseif not ev.match:find("c") then
        M.stop()
      end
      Util.trace()
    end,
  })

  vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
    group = group,
    callback = function(ev)
      Util.trace(ev.event .. "(" .. ev.buf .. ")")
      Buf.clear({ buf = ev.buf })
      Util.trace()
    end,
  })

  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNew" }, {
    group = group,
    callback = function(ev)
      Util.trace(ev.event .. "(" .. ev.buf .. ")")
      Buf.clear({ buf = ev.buf })
      Util.trace()
    end,
  })

  local current_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = group,
    callback = function(ev)
      current_buf = ev.buf ---@type number
      Util.trace(ev.event .. "(" .. ev.buf .. ")")
      Buf.get()
      Util.trace()
    end,
  })

  -- HACK: ModeChanged does not always trigger, so we need to manually
  -- check for mode changes. This seems to be due to the usage of `:norm` in autocmds.
  -- See https://github.com/folke/which-key.nvim/issues/787
  local timer = uv.new_timer()
  timer:start(0, 50, function()
    local mode = Util.mapmode()
    -- check if the mode exists for the current buffer
    if Buf.bufs[current_buf] and Buf.bufs[current_buf].modes[mode] then
      return
    end
    vim.schedule(Buf.get)
  end)
end

function M.stop()
  if M.state == nil then
    return
  end
  Util.debug("state:stop")
  M.state = nil
  vim.schedule(function()
    if not M.state then
      require("which-key.view").hide()
    end
  end)
end

---@param state wk.State
---@param key? string
---@return wk.Node? node
function M.check(state, key)
  local View = require("which-key.view")
  local node = key == nil and state.node or (key and state.node:find(key, { expand = true }))

  local delta = uv.hrtime() / 1e6 - state.started
  local timedout = vim.o.timeout and delta > vim.o.timeoutlen

  if node then
    -- NOTE: a node can be both a keymap and a group
    -- when it's both, we honor timeoutlen and nowait to decide what to do
    local has_children = node:count() > 0
    local is_nowait = node.keymap and (node.keymap.nowait == 1 or not timedout)
    local is_action = node.action ~= nil
    if has_children and not is_nowait and not is_action then
      Util.debug("continue", node.keys, tostring(state.mode), node.plugin)
      return node
    end
  elseif key == "<Esc>" then
    if state.mode:xo() then
      Util.exit() -- cancel and exit if in xo mode
    end
    return
  elseif key == "<BS>" then
    return state.node.parent or state.mode.tree.root
  elseif View.valid() and key == Config.keys.scroll_down then
    View.scroll(false)
    return state.node
  elseif View.valid() and key == Config.keys.scroll_up then
    View.scroll(true)
    return state.node
  end
  M.execute(state, key, node)
end

---@param state wk.State
---@param key? string
---@param node? wk.Node
---@return false|wk.Node?
function M.execute(state, key, node)
  Triggers.suspend(state.mode)

  if node and node.action then
    return node.action()
  end

  local keystr = node and node.keys or (state.node.keys .. (key or ""))
  if not state.mode:xo() then
    if vim.v.count > 0 and state.mode.mode ~= "i" and state.mode.mode ~= "c" then
      keystr = vim.v.count .. keystr
    end
    if vim.v.register ~= Util.reg() and state.mode.mode ~= "i" and state.mode.mode ~= "c" then
      keystr = '"' .. vim.v.register .. keystr
    end
  end
  Util.debug("feedkeys", tostring(state.mode), keystr)
  local feed = vim.api.nvim_replace_termcodes(keystr, true, true, true)
  vim.api.nvim_feedkeys(feed, "mit", false)
end

function M.getchar()
  return pcall(vim.fn.getcharstr)
end

---@param state wk.State
---@return wk.Node? node, boolean? exit
function M.step(state)
  M.redraw_timer:start(
    50,
    0,
    vim.schedule_wrap(function()
      if vim.api.nvim__redraw then
        vim.api.nvim__redraw({ cursor = true, valid = true, flush = true })
      else
        vim.cmd.redraw()
      end
    end)
  )
  vim.schedule(function() end)
  Util.debug("getchar")
  local ok, char = M.getchar()
  if not ok then
    Util.debug("nok", char)
    return nil, true
  end
  local key = vim.fn.keytrans(char)
  Util.debug("got", key)

  local node = M.check(state, key)
  if node == state.node then
    return M.step(state) -- same node, so try again (scrolling)
  end
  return node, key == "<Esc>"
end

---@param opts? wk.Filter
function M.start(opts)
  Util.trace("State(start)", function()
    local mode = opts and opts.mode or Util.mapmode()
    local buf = opts and opts.buf or 0
    local keys = opts and opts.keys or ""
    return { "Mode(" .. mode .. ":" .. buf .. ") Node(" .. keys .. ")", opts }
  end)

  opts = opts or {}
  opts.update = true
  local mode = Buf.get(opts)
  opts.update = nil
  if not mode then
    Util.debug("no mode")
    Util.trace()
    return false
  end
  local node = mode.tree:find(opts.keys or {}, { expand = true })
  if not node then
    Util.debug("no node")
    Util.trace()
    return false
  end

  local mapmode = mode.mode
  M.recursion = M.recursion + 1
  M.recursion_timer:start(500, 0, function()
    M.recursion = 0
  end)

  if M.recursion > 50 then
    Util.error({
      "Recursion detected.",
      "Are you manually loading which-key in a keymap?",
      "Use `opts.triggers` instead.",
      "Please check the docs.",
    })
    Util.debug("recursion detected. Aborting")
    Util.trace()
    return false
  end

  local View = require("which-key.view")

  M.state = {
    mode = mode,
    node = node,
    filter = opts,
    started = uv.hrtime() / 1e6 - (opts.waited or 0),
    show = opts.defer ~= true,
  }

  if not M.check(M.state) then
    Util.debug("executed")
    Util.trace()
    return true
  end

  local exit = false

  while M.state do
    mode = Buf.get(opts)
    if not mode or mode.mode ~= mapmode then
      break
    end
    if M.state.show then
      View.update(opts)
    end
    local child, _exit = M.step(M.state)
    if child and M.state then
      M.state.node = child
      M.state.show = true
    else
      exit = _exit or false
      break
    end
  end
  M.redraw_timer:stop()

  if opts.loop and not exit then
    -- NOTE: flush pending keys to prevent a trigger loop
    vim.api.nvim_feedkeys("", "x", false)
    vim.schedule(function()
      M.start(opts)
    end)
  else
    M.state = nil
    View.hide()
  end
  Util.trace()
  return true
end

function M.update()
  if not M.state then
    return
  end
  local mode = Buf.get()
  if not mode or mode.mode ~= M.state.mode.mode then
    return
  end
  local node = mode.tree:find(M.state.node.path)
  if not node then
    return
  end
  M.state.node = node
  require("which-key.view").update({ schedule = false })
end

---@param opts {delay?:number, mode:string, keys:string, plugin?:string, waited?: number}
function M.delay(opts)
  local delay = opts.delay or type(Config.delay) == "function" and Config.delay(opts) or Config.delay --[[@as number]]
  if opts.waited then
    delay = delay - opts.waited
  end
  return math.max(0, delay)
end

return M
