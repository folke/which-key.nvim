# 💥 Which Key

**WhichKey** is a lua plugin for Neovim 0.5 that displays a popup with possible keybindings of the command you started typing. Heavily inspired by the original [emacs-which-key](https://github.com/justbur/emacs-which-key) and [vim-which-key](https://github.com/liuchengxu/vim-which-key).

![image](https://user-images.githubusercontent.com/292349/116439438-669f8d00-a804-11eb-9b5b-c7122bd9acac.png)

## ✨ Features

* opens a poup with suggestions to complete a key binding
* works with any setting for [timeoutlen](https://neovim.io/doc/user/options.html#'timeoutlen'), including instantly (`timeoutlen=0`)
* works correctly with builtin keybindings
* works correctly with buffer-local mappings
* extensible plugin architecture
* builtin plugins:
  + **marks:** shows your marks when you hit one of the jump keys.
  + **registers:** shows the contents of your registers
  + **presets:** builtin keybinding help for `motions`, `text-objects`, `operators`, `windows`, `nav`, `z` and `g`

## ⚡️ Requirements

* Neovim >= 0.5.0

## 📦 Installation

Install the plugin with your preferred package manager:

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
" Vim Script
Plug 'folke/which-key.nvim'

lua << EOF
  require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF
```

### [packer](https://github.com/wbthomason/packer.nvim)

```lua
-- Lua
use {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end
}
```

## ⚙️ Configuration

> ❗️ IMPORTANT: the timeout when **WhichKey** opens is controlled by the vim setting [timeoutlen](https://neovim.io/doc/user/options.html#'timeoutlen'). Please refer to the documentation to properly set it up. Setting it to `0`, will effectively always show **WhichKey** immediately, but a setting of `500` (500ms) is probably more appropriate.

WhichKey comes with the following defaults:

```lua
{
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
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
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  window = {
    border = "none", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
  },
}
```

## 🪄 Setup

With the default settings, **WhichKey** will work out of the box for most builtin keybindings,
but the real power comes from documenting and organizing your own keybindings.

To document and/or setup your own mappings, you need to call the `register` method

```lua
local wk = require("which-key")
wk.register(mappings, opts)
```

Default options for `opts`

```lua
{
  mode = "n", -- NORMAL mode
  -- prefix: use "<leader>f" for example for mapping everything related to finding files
  -- the prefix is prepended to every mapping part of `mappings`
  prefix = "", 
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}
```

### Mappings

Group names use the special `name` key in the tables. There's multiple ways to define the mappings. See some examples below:

```lua
-- As an example, we will the following mappings:
--  1. <leader>fn new file
--  2. <leader>fr show recent files
--  2. <leader>ff find files
local wk = require("which-key")

-- method 1
wk.register({
  f = {
    name = "+file",
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    n = { "<cmd>enew<cr>", "New File" },
  },
}, { prefix = "<leader>" })

-- method 2
wk.register({
  ["<leader>"] = {
    f = {
      name = "+file",
      f = { "<cmd>Telescope find_files<cr>", "Find File" },
      r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
      n = { "<cmd>enew<cr>", "New File" },
    },
  },
})

-- method 3
wk.register({
  ["<leader>f"] = {
    name = "+file",
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    n = { "<cmd>enew<cr>", "New File" },
  },
})

-- method 4
wk.register({
  ["<leader>f"] = { name = "+file" },
  ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find File" },
  ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
  ["<leader>fn"] = { "<cmd>enew<cr>", "New File" },
})
```

If you just want to add help for the mapping, without creating it, you can do the following:

```lua
-- only pass one value in the mapping array to just add the help
wk.register({
  f = {
    name = "+file",
    f = { "Find File" },
    r = { "Open Recent File" },
  },
}, { prefix = "<leader>" })

-- or just pass a string
wk.register({
  f = {
    name = "+file",
    f = "Find File",
    r = "Open Recent File",
  },
}, { prefix = "<leader>" })
```

You can also pass specific options to some keybinding

```lua
wk.register({
  f = {
    name = "+file",
    f = { "Find File", noremap = false, buffer = 123 },
    r = { "Open Recent File" },
  },
}, { prefix = "<leader>" })
```

Ignore some keybindings in **WhichKey** by setting their label to `which_key_ignore`

```lua
wk.register({
    ["<leader>0"] = "which_key_ignore",
    ["<leader>1"] = "which_key_ignore",
})
```

## 🚀 Usage

When the **WhichKey** popup is open, you can use the following keybindings (they are also displayed at the bottom of the screen):

* hit one of the keys to open a group or execute a key binding
* `<esc>` to cancel and close the popup
* `<bs>` go up one level
* `<c-d>` scroll down
* `<c-u>` scroll up

Apart from the automatic opening, you can also  manually open **WhichKey** for a certain `prefix`:

```vim
:WhichKey " show all mappings
:WhichKey <leader> " show all <leader> mappings
:WhichKey <leader> v " show all <leader> mappings for VISUAL mode
```

## 🔥 Plugins

Three builtin plugins are included with **WhichKey**.

### Marks

Shows a list of your buffer local and global marks when you hit \` or '

![image](https://user-images.githubusercontent.com/292349/116439573-8f278700-a804-11eb-80ca-bb9263e6d937.png)

### Registers

Shows a list of your buffer local and global registers when you hit " in *NORMAL* mode, or `<c-r>` in *INSERT* mode.

![image](https://user-images.githubusercontent.com/292349/116439609-98b0ef00-a804-11eb-9385-97c7d5ff4113.png)

### Presets

Builtin keybinding help for `motions`, `text-objects`, `operators`, `windows`, `nav`, `z` and `g`

![image](https://user-images.githubusercontent.com/292349/116439871-df9ee480-a804-11eb-9529-800e167db65c.png)

## 🎨 Colors

The table below shows all the highlight groups defined for LSP Trouble with their default link.

| Highlight Group     | Defaults to | Description                                 |
| ------------------- | ----------- | ------------------------------------------- |
| *WhichKey*          | Function    | the key                                     |
| *WhichKeyGroup*     | Keyword     | a group                                     |
| *WhichKeySeparator* | DiffAdded   | the separator between the key and its label |
| *WhichKeyDesc*      | Identifier  | the label of the key                        |
| *WhichKeyFloat*     | NormalFloat | Normal in the popup window                  |
| *WhichKeyValue*     | Comment     | used by plugins that provide values         |
