local Keys = require("which-key.keys")
local config = require("which-key.config")
local Layout = require("which-key.layout")
local Util = require("which-key.util")

local highlight = vim.api.nvim_buf_add_highlight

---@class View
local M = {}

M.keys = ""
M.mode = "n"
M.reg = nil
M.auto = false
M.count = 0
M.buf = nil
M.win = nil

function M.is_valid()
  return M.buf
    and M.win
    and vim.api.nvim_buf_is_valid(M.buf)
    and vim.api.nvim_buf_is_loaded(M.buf)
    and vim.api.nvim_win_is_valid(M.win)
end

function M.show()
  if vim.b.visual_multi then
    vim.b.VM_skip_reset_once_on_bufleave = true
  end
  if M.is_valid() then
    return
  end

  -- non-floating windows
  local wins = vim.tbl_filter(function(w)
    return vim.api.nvim_win_is_valid(w) and vim.api.nvim_win_get_config(w).relative == ""
  end, vim.api.nvim_list_wins())

  ---@type number[]
  local margins = {}
  for i, m in ipairs(config.options.window.margin) do
    if m > 0 and m < 1 then
      if i % 2 == 0 then
        m = math.floor(vim.o.columns * m)
      else
        m = math.floor(vim.o.lines * m)
      end
    end
    margins[i] = m
  end

  local opts = {
    relative = "editor",
    width = vim.o.columns
      - margins[2]
      - margins[4]
      - (vim.fn.has("nvim-0.6") == 0 and config.options.window.border ~= "none" and 2 or 0),
    height = config.options.layout.height.min,
    focusable = false,
    anchor = "SW",
    border = config.options.window.border,
    row = vim.o.lines
      - margins[3]
      - (vim.fn.has("nvim-0.6") == 0 and config.options.window.border ~= "none" and 2 or 0)
      + ((vim.o.laststatus == 0 or vim.o.laststatus == 1 and #wins == 1) and 1 or 0)
      - vim.o.cmdheight,
    col = margins[4],
    style = "minimal",
    noautocmd = true,
    zindex = config.options.window.zindex,
  }
  if config.options.window.position == "top" then
    opts.anchor = "NW"
    opts.row = margins[1]
  end
  M.buf = vim.api.nvim_create_buf(false, true)
  M.win = vim.api.nvim_open_win(M.buf, false, opts)
  vim.api.nvim_buf_set_option(M.buf, "filetype", "WhichKey")
  vim.api.nvim_buf_set_option(M.buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(M.buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(M.buf, "modifiable", true)

  local winhl = "NormalFloat:WhichKeyFloat"
  if vim.fn.hlexists("FloatBorder") == 1 then
    winhl = winhl .. ",FloatBorder:WhichKeyBorder"
  end
  vim.api.nvim_win_set_option(M.win, "winhighlight", winhl)
  vim.api.nvim_win_set_option(M.win, "foldmethod", "manual")
  vim.api.nvim_win_set_option(M.win, "winblend", config.options.window.winblend)
end

function M.read_pending()
  local esc = ""
  while true do
    local n = vim.fn.getchar(0)
    if n == 0 then
      break
    end
    local c = (type(n) == "number" and vim.fn.nr2char(n) or n)

    -- HACK: for some reason, when executing a :norm command,
    -- vim keeps feeding <esc> at the end
    if c == Util.t("<esc>") then
      esc = esc .. c
      -- more than 10 <esc> in a row? most likely the norm bug
      if #esc > 10 then
        return
      end
    else
      -- we have <esc> characters, so add them to keys
      if esc ~= "" then
        M.keys = M.keys .. esc
        esc = ""
      end
      M.keys = M.keys .. c
    end
  end
  if esc ~= "" then
    M.keys = M.keys .. esc
    esc = ""
  end
end

function M.getchar()
  local ok, n = pcall(vim.fn.getchar)

  -- bail out on keyboard interrupt
  if not ok then
    return Util.t("<esc>")
  end

  local c = (type(n) == "number" and vim.fn.nr2char(n) or n)
  return c
end

function M.scroll(up)
  local height = vim.api.nvim_win_get_height(M.win)
  local cursor = vim.api.nvim_win_get_cursor(M.win)
  if up then
    cursor[1] = math.max(cursor[1] - height, 1)
  else
    cursor[1] = math.min(cursor[1] + height, vim.api.nvim_buf_line_count(M.buf))
  end
  vim.api.nvim_win_set_cursor(M.win, cursor)
end

function M.on_close()
  M.hide()
end

function M.hide()
  vim.api.nvim_echo({ { "" } }, false, {})
  M.hide_cursor()
  if M.buf and vim.api.nvim_buf_is_valid(M.buf) then
    vim.api.nvim_buf_delete(M.buf, { force = true })
    M.buf = nil
  end
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
    M.win = nil
  end
  vim.cmd("redraw")
end

function M.show_cursor()
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_add_highlight(buf, config.namespace, "Cursor", cursor[1] - 1, cursor[2], cursor[2] + 1)
end

function M.hide_cursor()
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(buf, config.namespace, 0, -1)
end

function M.back()
  local node = Keys.get_tree(M.mode, M.buf).tree:get(M.keys, -1) or Keys.get_tree(M.mode).tree:get(M.keys, -1)
  if node then
    M.keys = node.prefix_i
  end
end

function M.execute(prefix_i, mode, buf)
  local global_node = Keys.get_tree(mode).tree:get(prefix_i)
  local buf_node = buf and Keys.get_tree(mode, buf).tree:get(prefix_i) or nil

  if global_node and global_node.mapping and Keys.is_hook(prefix_i, global_node.mapping.cmd) then
    return
  end
  if buf_node and buf_node.mapping and Keys.is_hook(prefix_i, buf_node.mapping.cmd) then
    return
  end

  local hooks = {}

  local function unhook(nodes, nodes_buf)
    for _, node in pairs(nodes) do
      if Keys.is_hooked(node.mapping.prefix, mode, nodes_buf) then
        table.insert(hooks, { node.mapping.prefix, nodes_buf })
        Keys.hook_del(node.mapping.prefix, mode, nodes_buf)
      end
    end
  end

  -- make sure we remove all WK hooks before executing the sequence
  -- this is to make existing keybindongs work and prevent recursion
  unhook(Keys.get_tree(mode).tree:path(prefix_i))
  if buf then
    unhook(Keys.get_tree(mode, buf).tree:path(prefix_i), buf)
  end

  -- feed CTRL-O again if called from CTRL-O
  local full_mode = Util.get_mode()
  if full_mode == "nii" or full_mode == "nir" or full_mode == "niv" or full_mode == "vs" then
    vim.api.nvim_feedkeys(Util.t("<C-O>"), "n", false)
  end

  -- handle registers that were passed when opening the popup
  if M.reg ~= '"' and M.mode ~= "i" and M.mode ~= "c" then
    vim.api.nvim_feedkeys('"' .. M.reg, "n", false)
  end

  if M.count and M.count ~= 0 then
    prefix_i = M.count .. prefix_i
  end

  -- feed the keys with remap
  vim.api.nvim_feedkeys(prefix_i, "m", true)

  -- defer hooking WK until after the keys were executed
  vim.defer_fn(function()
    for _, hook in pairs(hooks) do
      Keys.hook_add(hook[1], mode, hook[2])
    end
  end, 0)
end

function M.open(keys, opts)
  opts = opts or {}
  M.keys = keys or ""
  M.mode = opts.mode or Util.get_mode()
  M.count = vim.api.nvim_get_vvar("count")
  M.reg = vim.api.nvim_get_vvar("register")

  if string.find(vim.o.clipboard, "unnamedplus") and M.reg == "+" then
    M.reg = '"'
  end

  if string.find(vim.o.clipboard, "unnamed") and M.reg == "*" then
    M.reg = '"'
  end

  M.show_cursor()
  M.on_keys(opts)
end

function M.is_enabled(buf)
  local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
  for _, bt in ipairs(config.options.disable.buftypes) do
    if bt == buftype then
      return false
    end
  end

  local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
  for _, bt in ipairs(config.options.disable.filetypes) do
    if bt == filetype then
      return false
    end
  end

  return true
end

function M.on_keys(opts)
  local buf = vim.api.nvim_get_current_buf()

  while true do
    -- loop
    M.read_pending()

    local results = Keys.get_mappings(M.mode, M.keys, buf)

    --- Check for an exact match. Feedkeys with remap
    if results.mapping and not results.mapping.group and #results.mappings == 0 then
      M.hide()
      if results.mapping.fn then
        results.mapping.fn()
      else
        M.execute(M.keys, M.mode, buf)
      end
      return
    end

    -- Check for no mappings found. Feedkeys without remap
    if #results.mappings == 0 then
      M.hide()
      -- only execute if an actual key was typed while WK was open
      if opts.auto then
        M.execute(M.keys, M.mode, buf)
      end
      return
    end

    local layout = Layout:new(results)

    if M.is_enabled(buf) then
      if not M.is_valid() then
        M.show()
      end

      M.render(layout:layout(M.win))
    end
    vim.cmd([[redraw]])

    local c = M.getchar()

    if c == Util.t("<esc>") then
      M.hide()
      break
    elseif c == Util.t(config.options.popup_mappings.scroll_down) then
      M.scroll(false)
    elseif c == Util.t(config.options.popup_mappings.scroll_up) then
      M.scroll(true)
    elseif c == Util.t("<bs>") then
      M.back()
    else
      M.keys = M.keys .. c
    end
  end
end

---@param text Text
function M.render(text)
  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, text.lines)
  local height = #text.lines
  if height > config.options.layout.height.max then
    height = config.options.layout.height.max
  end
  vim.api.nvim_win_set_height(M.win, height)
  if vim.api.nvim_buf_is_valid(M.buf) then
    vim.api.nvim_buf_clear_namespace(M.buf, config.namespace, 0, -1)
  end
  for _, data in ipairs(text.hl) do
    highlight(M.buf, config.namespace, data.group, data.line, data.from, data.to)
  end
end

return M
