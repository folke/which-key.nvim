# 💥 Which Key

**WhichKey** helps you remember your Neovim keymaps, by showing available keybindings
in a popup as you type.

![image](https://github.com/user-attachments/assets/89277334-dcdc-4b0f-9fd4-02f27012f589)
![image](https://github.com/user-attachments/assets/f8d71a75-312e-4a42-add8-d153493b2633)
![image](https://github.com/user-attachments/assets/e4400a1d-7e71-4439-b6ff-6cbc40647a6f)

## ✨ Features

- 🔍 **Key Binding Help**: show available keybindings in a popup as you type.
- ⌨️ **Modes**: works in normal, insert, visual, operator pending, terminal and command mode.
  Every mode can be enabled/disabled.
- 🛠️ **Customizable Layouts**: choose from `classic`, `modern`, and `helix` presets or customize the window.
- 🔄 **Flexible Sorting**: sort by `local`, `order`, `group`, `alphanum`, `mod`, `lower`, `icase`, `desc`, or `manual`.
- 🎨 **Formatting**: customizable key labels and descriptions
- 🖼️ **Icons**: integrates with [mini.icons](https://github.com/echasnovski/mini.icons) and [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- ⏱️ **Delay**: delay is independent of `timeoutlen`
- 🌐 **Plugins**: built-in plugins for marks, registers, presets, and spelling suggestions
- 🚀 **Operators, Motions, Text Objects**: help for operators, motions and text objects
- 🐙 **Hydra Mode**: keep the popup open until you hit `<esc>`

## ⚡️ Requirements

- **Neovim** >= 0.9.4
- for proper icons support:
  - [mini.icons](https://github.com/echasnovski/mini.icons) _(optional)_
  - [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) _(optional)_
  - a [Nerd Font](https://www.nerdfonts.com/) **_(optional)_**

## 📦 Installation

Install the plugin with your package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
```

## ⚙️ Configuration

> [!important]
> Make sure to run `:checkhealth which-key` if something isn't working properly

**WhichKey** is highly configurable. Expand to see the list of all the default options below.

<details><summary>Default Options</summary>

<!-- config:start -->

```lua
---@class wk.Opts
local defaults = {
  ---@type false | "classic" | "modern" | "helix"
  preset = "classic",
  -- Delay before showing the popup. Can be a number or a function that returns a number.
  ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
  delay = function(ctx)
    return ctx.plugin and 0 or 200
  end,
  ---@param mapping wk.Mapping
  filter = function(mapping)
    -- example to exclude mappings without a description
    -- return mapping.desc and mapping.desc ~= ""
    return true
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
    -- Start hidden and wait for a key to be pressed before showing the popup
    -- Only used by enabled xo mapping modes.
    -- Set to false to show the popup immediately (after the delay)
    defer = {
      ["<C-V>"] = true,
      V = true,
      -- Defer certain operators. Only used for operator pending mode.
      operators = {
        -- d = true, -- defer delete
      },
    },
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
  ---@type wk.Win.opts
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
  --- Mappings are sorted using configured sorters and natural sort of the keys
  --- Available sorters:
  --- * local: buffer-local mappings first
  --- * order: order of the items (Used by plugins like marks / registers)
  --- * group: groups last
  --- * alphanum: alpha-numerical first
  --- * mod: special modifier keys last
  --- * manual: the order the mappings were added
  --- * case: lower-case first
  sort = { "local", "order", "group", "alphanum", "mod" },
  ---@type number|fun(node: wk.Node):boolean?
  expand = 0, -- expand groups when <= n mappings
  -- expand = function(node)
  --   return not node.desc -- expand all nodes without a description
  -- end,
  -- Functions/Lua Patterns for formatting the labels
  ---@type table<string, ({[1]:string, [2]:string}|fun(str:string):string)[]>
  replace = {
    key = {
      function(key)
        return require("which-key.view").format(key)
      end,
      -- { "<Space>", "SPC" },
    },
    desc = {
      { "<Plug>%(?(.*)%)?", "%1" },
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
    -- set to false to disable all mapping icons,
    -- both those explicitely added in a mapping
    -- and those from rules
    mappings = true,
    --- See `lua/which-key/icons.lua` for more details
    --- Set to `false` to disable keymap icons from rules
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
      D = "󰘳 ",
      S = "󰘶 ",
      CR = "󰌑 ",
      Esc = "󱊷 ",
      ScrollWheelDown = "󱕐 ",
      ScrollWheelUp = "󱕑 ",
      NL = "󰌑 ",
      BS = "󰁮",
      Space = "󱁐 ",
      Tab = "󰌒 ",
      F1 = "󱊫",
      F2 = "󱊬",
      F3 = "󱊭",
      F4 = "󱊮",
      F5 = "󱊯",
      F6 = "󱊰",
      F7 = "󱊱",
      F8 = "󱊲",
      F9 = "󱊳",
      F10 = "󱊴",
      F11 = "󱊵",
      F12 = "󱊶",
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
```

<!-- config:end -->

</details>

## ⌨️ Setup

**WhichKey** automatically gets the descriptions of your keymaps from the `desc`
attribute of the keymap. So for most use-cases, you don't need to do anything else.

However, the **mapping spec** is still useful to configure group descriptions and mappings that don't really exist as a regular keymap.

> [!WARNING]
> The **mappings spec** changed in `v3`, so make sure to only use the new `add` method if
> you updated your existing mappings.

Mappings can be added as part of the config `opts.spec`, or can be added later
using `require("which-key").add()`.
`wk.add()` can be called multiple times from anywhere in your config files.

A mapping has the following attributes:

- **[1]**: (`string`) lhs **_(required)_**
- **[2]**: (`string|fun()`) rhs **_(optional)_**: when present, it will create the mapping
- **desc**: (`string|fun():string`) description **_(required for non-groups)_**
- **group**: (`string|fun():string`) group name **_(optional)_**
- **mode**: (`string|string[]`) mode **_(optional, defaults to `"n"`)_**
- **cond**: (`boolean|fun():boolean`) condition to enable the mapping **_(optional)_**
- **hidden**: (`boolean`) hide the mapping **_(optional)_**
- **icon**: (`string|wk.Icon|fun():(wk.Icon|string)`) icon spec **_(optional)_**
- **proxy**: (`string`) proxy to another mapping **_(optional)_**
- **expand**: (`fun():wk.Spec`) nested mappings **_(optional)_**
- any other option valid for `vim.keymap.set`. These are only used for creating mappings.

When `desc`, `group`, or `icon` are functions, they are evaluated every time
the popup is shown.

The `expand` property allows to create dynamic mappings.
Two examples are included in `which-key.extras`:

- `require("which-key.extras").exapand.buf`: creates numerical key to buffer mappings
- `require("which-key.extras").exapand.win`: creates numerical key to window mappings

```lua
local wk = require("which-key")
wk.add({
  { "<leader>f", group = "file" }, -- group
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
  { "<leader>fb", function() print("hello") end, desc = "Foobar" },
  { "<leader>fn", desc = "New File" },
  { "<leader>f1", hidden = true }, -- hide this keymap
  { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings
  { "<leader>b", group = "buffers", expand = function()
      return require("which-key.extras").expand.buf()
    end
  },
  {
    -- Nested mappings are allowed and can be added in any order
    -- Most attributes can be inherited or overridden on any level
    -- There's no limit to the depth of nesting
    mode = { "n", "v" }, -- NORMAL and VISUAL mode
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
    { "<leader>w", "<cmd>w<cr>", desc = "Write" },
  }
})
```

## 🎨 Icons

> [!note]
> For full support, you need to install either [mini.icons](https://github.com/echasnovski/mini.icons) or [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)

There's multiple ways to set icons for your keymaps:

- if you use lazy.nvim, then some icons will be autodetected for keymaps belonging to certain plugins.
- custom rules to decide what icon to use
- in your mapping spec, you can specify what icon to use at any level, so at the node for `<leader>g` for example, to apply to all git keymaps.

The `icon` attribute of a mapping can be a `string`, which will be used as the actual icon,
or an `wk.Icon` object, which can have the following attributes:

- `icon` (`string`): the icon to use **_(optional)_**
- `hl` (`string`): the highlight group to use for the icon **_(optional)_**
- `color` (`string`): the color to use for the icon **_(optional)_**
  valid colors are: `azure`, `blue`, `cyan`, `green`, `grey`, `orange`, `purple`, `red`, `yellow`
- `cat` (`string`): the category of the icon **_(optional)_**
  valid categories are: `file`, `filetype`, `extension`
- `name` (`string`): the name of the icon in the specified category **_(optional)_**

> [!TIP]
> If you'd rather not use icons, you can disable them
> by setting `opts.icons.mappings` to `false`.

## 🚀 Usage

When the **WhichKey** popup is open, you can use the following key bindings (they are also displayed at the bottom of the screen):

- hit one of the keys to open a group or execute a key binding
- `<esc>` to cancel and close the popup
- `<bs>` go up one level
- `<c-d>` scroll down
- `<c-u>` scroll up

## 🐙 Hydra Mode

Hydra mode is a special mode that keeps the popup open until you hit `<esc>`.

```lua
-- Show hydra mode for changing windows
require("which-key").show({
  keys = "<c-w>",
  loop = true, -- this will keep the popup open until you hit <esc>
})
```

## 🔥 Plugins

Four built-in plugins are included with **WhichKey**.

### Presets

Built-in key binding help for `motions`, `text-objects`, `operators`, `windows`, `nav`, `z` and `g` and more.

### Marks

Shows a list of your buffer local and global marks when you hit \` or '

![image](https://github.com/user-attachments/assets/43fb0874-7f79-4521-aee9-03e2b0841758)

### Registers

Shows a list of your buffer local and global registers when you hit " in _NORMAL_ mode, or `<c-r>` in _INSERT_ mode.

![image](https://github.com/user-attachments/assets/d8077dcb-56fb-47b0-ad9e-1aba5db16950)

### Spelling

When enabled, this plugin hooks into `z=` and replaces the full-screen spelling suggestions window by a list of suggestions within **WhichKey**.

![image](https://github.com/user-attachments/assets/102c7963-329a-40b9-b0a8-72c8656318b7)

## 🎨 Colors

The table below shows all the highlight groups defined for **WhichKey** with their default link.

<!-- colors:start -->

| Highlight Group | Default Group | Description |
| --- | --- | --- |
| **WhichKey** | ***Function*** |  |
| **WhichKeyBorder** | ***FloatBorder*** | Border of the which-key window |
| **WhichKeyDesc** | ***Identifier*** | description |
| **WhichKeyGroup** | ***Keyword*** | group name |
| **WhichKeyIcon** | ***@markup.link*** | icons |
| **WhichKeyIconAzure** | ***Function*** |  |
| **WhichKeyIconBlue** | ***DiagnosticInfo*** |  |
| **WhichKeyIconCyan** | ***DiagnosticHint*** |  |
| **WhichKeyIconGreen** | ***DiagnosticOk*** |  |
| **WhichKeyIconGrey** | ***Normal*** |  |
| **WhichKeyIconOrange** | ***DiagnosticWarn*** |  |
| **WhichKeyIconPurple** | ***Constant*** |  |
| **WhichKeyIconRed** | ***DiagnosticError*** |  |
| **WhichKeyIconYellow** | ***DiagnosticWarn*** |  |
| **WhichKeyNormal** | ***NormalFloat*** | Normal in th which-key window |
| **WhichKeySeparator** | ***Comment*** | the separator between the key and its description |
| **WhichKeyTitle** | ***FloatTitle*** | Title of the which-key window |
| **WhichKeyValue** | ***Comment*** | values by plugins (like marks, registers, etc) |

<!-- colors:end -->
