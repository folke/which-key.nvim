---@class wk.Config: wk.Opts
local M = {}

M.version = "3.2.0" -- x-release-please-version

---@class wk.Opts
local defaults = {
  ---@type false | "classic" | "modern" | "helix"
  preset = "helix",
  -- Delay before showing the popup. Can be a number or a function that returns a number.
  ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
  delay = function(ctx)
    return ctx.plugin and 0 or 200
  end,
  --- You can add any mappings here, or use `require('which-key').add()` later
  ---@type wk.Spec
  spec = {},
  -- show a warning when issues were detected with your mappings
  notify = true,
  -- Enable/disable WhichKey for certain mapping modes
  modes = {
    n = true, -- Normal mode
    i = true, -- Insert mode
    x = true, -- Visual mode
    s = true, -- Select mode
    o = true, -- Operator pending mode
    t = true, -- Terminal mode
    c = true, -- Command mode
  },
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = true, -- adds help for operators like d, y, ...
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  ---@type wk.Win
  win = {
    -- don't allow the popup to overlap with the cursor
    no_overlap = true,
    -- width = 1,
    -- height = { min = 4, max = 25 },
    -- col = 0,
    -- row = math.huge,
    -- border = "none",
    padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
    title = true,
    title_pos = "center",
    zindex = 1000,
    -- Additional vim.wo and vim.bo options
    bo = {},
    wo = {
      -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
    },
  },
  layout = {
    width = { min = 20 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  keys = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  ---@type (string|wk.Sorter)[]
  --- Add "manual" as the first element to use the order the mappings were registered
  --- Other sorters: "desc"
  sort = { "local", "order", "group", "alphanum", "mod", "lower", "icase" },
  expand = 1, -- expand groups when <= n mappings
  ---@type table<string, ({[1]:string, [2]:string}|fun(str:string):string)[]>
  replace = {
    key = {
      function(key)
        return require("which-key.view").format(key)
      end,
      -- { "<Space>", "SPC" },
    },
    desc = {
      { "<Plug>%((.*)%)", "%1" },
      { "^%+", "" },
      { "<[cC]md>", "" },
      { "<[cC][rR]>", "" },
      { "<[sS]ilent>", "" },
      { "^lua%s+", "" },
      { "^call%s+", "" },
      { "^:%s*", "" },
    },
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
    ellipsis = "…",
    --- See `lua/which-key/icons.lua` for more details
    --- Set to `false` to disable keymap icons
    ---@type wk.IconRule[]|false
    rules = {},
    -- use the highlights from mini.icons
    -- When `false`, it will use `WhichKeyIcon` instead
    colors = true,
    -- used by key format
    keys = {
      Up = " ",
      Down = " ",
      Left = " ",
      Right = " ",
      C = "󰘴 ",
      M = "󰘵 ",
      S = "󰘶 ",
      CR = "󰌑 ",
      Esc = "󱊷 ",
      ScrollWheelDown = "󱕐 ",
      ScrollWheelUp = "󱕑 ",
      NL = "󰌑 ",
      BS = "⌫",
      Space = "󱁐 ",
      Tab = "󰌒 ",
    },
  },
  show_help = true, -- show a help message in the command line for using WhichKey
  show_keys = true, -- show the currently pressed key and its label as a message in the command line
  -- Which-key automatically sets up triggers for your mappings.
  -- But you can disable this and setup the triggers yourself.
  -- Be aware, that triggers are not needed for visual and operator pending mode.
  triggers = true, -- automatically setup triggers
  disable = {
    -- disable WhichKey for certain buf types and file types.
    ft = {},
    bt = {},
    -- disable a trigger for a certain context by returning true
    ---@type fun(ctx: { keys: string, mode: string, plugin?: string }):boolean?
    trigger = function(ctx)
      return false
    end,
  },
  debug = false, -- enable wk.log in the current directory
}

M.loaded = false

---@type wk.Keymap[]
M.mappings = {}

---@type wk.Opts
M.options = nil

---@param opts? wk.Opts
function M.setup(opts)
  if vim.fn.has("nvim-0.9") == 0 then
    return vim.notify("which-key.nvim requires Neovim >= 0.9", vim.log.levels.ERROR)
  end
  M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})

  local function load()
    if M.loaded then
      return
    end

    if M.options.preset then
      local Presets = require("which-key.presets")
      M.options = vim.tbl_deep_extend("force", {}, defaults, Presets[M.options.preset] or {}, opts or {})
    end
    local wk = require("which-key")

    -- replace by the real add function
    wk.add = M.add

    -- load presets first so that they can be overriden by the user
    require("which-key.plugins").setup()

    -- process mappings queue
    for _, todo in ipairs(wk._queue) do
      M.add(todo.spec, todo.opts)
    end
    wk._queue = {}

    -- finally, add the mapppings from the config
    M.add(M.options.spec)

    -- setup colors and start which-key
    require("which-key.colors").setup()
    require("which-key.state").setup()

    if M.options.debug then
      require("which-key.util").debug("\n\nDebug Started for v" .. M.version)
    end

    M.loaded = true
  end
  load = vim.schedule_wrap(load)

  if vim.v.vim_did_enter == 1 then
    load()
  else
    vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = load })
  end

  vim.api.nvim_create_user_command("WhichKey", function(cmd)
    local mode, keys = cmd.args:match("^([nixsotc]?)%s*(.*)$")
    if not mode then
      return require("which-key.util").error("Usage: WhichKey [mode] [keys]")
    end
    if mode == "" then
      mode = "n"
    end
    require("which-key").show({ mode = mode, keys = keys })
  end, {
    nargs = "*",
  })
end

---@param opts? wk.Parse
---@param mappings wk.Spec
function M.add(mappings, opts)
  opts = opts or {}
  opts.create = opts.create ~= false
  local Mappings = require("which-key.mappings")
  for _, km in ipairs(Mappings.parse(mappings, opts)) do
    table.insert(M.mappings, km)
    km.idx = #M.mappings
  end
  if M.loaded then
    require("which-key.buf").clear()
  end
end

return setmetatable(M, {
  __index = function(_, k)
    if rawget(M, "options") == nil then
      M.setup()
    end
    local opts = rawget(M, "options")
    return k == "options" and opts or opts[k]
  end,
})
