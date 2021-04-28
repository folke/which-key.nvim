# 🧐 Which Key

**WhichKey** is a lua plugin for Neovim 0.5 that displays a popup with possible keybindings of the command you started typing. 

## ✨ Features

* opens a poup

## ⚡️ Requirements

* Neovim >= 0.5.0
* Properly configured Neovim LSP client
* [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) is optional to enable file icons
* a theme with properly configured highlight groups for Neovim LSP Diagnostics
* or install 🌈  [lsp-colors](https://github.com/folke/lsp-colors.nvim) to automatically create the missing highlight groups
* a [patched font](https://www.nerdfonts.com/) for the default severity and fold icons

## 📦 Installation

Install the plugin with your preferred package manager:

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
" Vim Script
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/lsp-trouble.nvim'

lua << EOF
  require("trouble").setup {
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
  "folke/lsp-trouble.nvim",
  requires = "kyazdani42/nvim-web-devicons",
  config = function()
    require("trouble").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end
}
```

## ⚙️ Configuration

### Setup

Trouble comes with the following defaults:

```lua
{
    height = 10, -- height of the trouble list
    icons = true, -- use dev-icons for filenames
    mode = "workspace", -- "workspace" or "document"
    fold_open = "", -- icon used for open folds
    fold_closed = "", -- icon used for closed folds
    action_keys = { -- key mappings for actions in the trouble list
        close = "q", -- close the list
        cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r", -- manually refresh
        jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
        toggle_mode = "m", -- toggle between "workspace" and "document" mode
        toggle_preview = "P", -- toggle auto_preview
        preview = "p", -- preview the diagnostic location
        close_folds = {"zM", "zm"}, -- close all folds
        open_folds = {"zR", "zr"}, -- open all folds
        toggle_fold = {"zA", "za"}, -- toggle fold of current file
        previous = "k", -- preview item
        next = "j" -- next item
    },
    indent_lines = true, -- add an indent guide below the fold icons
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = false, -- automatically close the list when you have no diagnostics
    auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back
    auto_fold = false, -- automatically fold a file trouble list at creation
    signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = ""
    },
    use_lsp_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
}
```

> 💡 if you don't want to use icons or a patched font, you can use the settings below

```lua
-- settings without a patched font or icons
{
    fold_open = "v", -- icon used for open folds
    fold_closed = ">", -- icon used for closed folds
    indent_lines = false, -- add an indent guide below the fold icons
    signs = {
        -- icons / text used for a diagnostic
        error = "error",
        warning = "warn",
        hint = "hint",
        information = "info"
    },
    use_lsp_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
}
```

## 🚀 Usage

### Commands

Trouble comes with the following commands:

* **LspTroubleOpen**: open the list
* **LspTroubleWorkspaceOpen**: set mode to "workspace" and open the list
* **LspTroubleDocumentOpen**: set mode to "document" and open the list
* **LspTroubleClose**: close the list
* **LspTroubleToggle**: toggle the list
* **LspTroubleWorkspaceToggle**: set mode to "workspace" and toggle the list (remains open if mode changes)
* **LspTroubleDocumentToggle**: set mode to "document" and toggle the list (remains open if mode changes)
* **LspTroubleRefresh**: manually refresh

Example keybinding of `<leader>xx` that toggles the trouble list:

```vim
-- Vim Script
nnoremap <leader>xx <cmd>LspTroubleToggle<cr>
```

```lua
-- Lua
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>LspTroubleToggle<cr>",
  {silent = true, noremap = true}
)
```

## 🎨 Colors

The table below shows all the highlight groups defined for LSP Trouble with their default link.

| Highlight Group             | Defaults to                      |
| --------------------------- | -------------------------------- |
| *LspTroubleCount*           | TabLineSel                       |
| *LspTroubleError*           | LspDiagnosticsDefaultError       |
| *LspTroubleNormal*          | Normal                           |
| *LspTroubleTextInformation* | LspTroubleText                   |
| *LspTroubleSignWarning*     | LspDiagnosticsSignWarning        |
| *LspTroubleLocation*        | LineNr                           |
| *LspTroubleWarning*         | LspDiagnosticsDefaultWarning     |
| *LspTroublePreview*         | Search                           |
| *LspTroubleTextError*       | LspTroubleText                   |
| *LspTroubleSignInformation* | LspDiagnosticsSignInformation    |
| *LspTroubleIndent*          | LineNr                           |
| *LspTroubleSource*          | Comment                          |
| *LspTroubleSignHint*        | LspDiagnosticsSignHint           |
| *LspTroubleFoldIcon*        | CursorLineNr                     |
| *LspTroubleTextWarning*     | LspTroubleText                   |
| *LspTroubleCode*            | Comment                          |
| *LspTroubleInformation*     | LspDiagnosticsDefaultInformation |
| *LspTroubleSignError*       | LspDiagnosticsSignError          |
| *LspTroubleFile*            | Directory                        |
| *LspTroubleHint*            | LspDiagnosticsDefaultHint        |
| *LspTroubleTextHint*        | LspTroubleText                   |
| *LspTroubleText*            | Normal                           |



# Todo

* [x] hook into all groups
* [x] show mappings without keymap (zz etc)
* [x] plugin support for marks, registers, text objects
* [x] `<bs>` to go up a level
* [x] config modes
* [x] update buf only
* [x] + thingy for groups
* [x] text objects
* [x] get label from global when not found for buffer
* [x] operators & motions
* [ ] show window after timeout?
* [x] make plugins a list of key value with config in value
* [x] cleanup text objects text
* [x] buf local mappings seems to interfere with global mappings (push K in help)
* [x] fix help in visual mode
* [ ] Plug>whichkey nop
* [ ] preset plugin
* [ ] command should auto stuff
