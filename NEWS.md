# 💥 What's New in 3.0?

Major update for [which-key.nvim](https://github.com/folke/which-key.nvim)! This release includes a complete rewrite and several new features.
**which-key** was my very first plugin, so it was time for a fresh start. 🎉

- ✨ **Full Rewrite**: Improved performance and functionality.
- 👀 **Visual & Operator Pending Mode Integration**: Now uses `ModeChanged`, eliminating the need for operator remappings.
- 🔧 **Simplified Mappings**: Removed obscure secret mappings.
- 🔒 **Safer Auto Triggers**: Auto triggers are now never created for single keys apart from `g` and `z`. All other letters are unsafe.
- ⏱️ **Delay**: Set delay independently of `timeoutlen`.
- 🛠️ **Layout**:
  - Presets: `classic`, `modern`, and `helix`.
  - Enable/disable which-key for specific modes.
  - Configurable sorting with options like `local`, `order`, `group`, `alphanum`, `mod`, `lower`, `icase`, `desc`, and `manual`.
  - Expand groups with fewer keymaps.
  - Customizable string replacements for `key` and `desc`.
- 🎨 **Icon Support**:
  - Auto-detect icons for keymaps using `lazy.nvim`.
  - Custom icon rules and specifications for mapping levels.
- 🚫 **Never Get in the Way**: Avoids overlapping with the cursor.
- 🗂️ **New Mapping Spec**: New and better mappings spec, more in line with `vim.keymap.set` and how you define keymaps with [lazy.nvim](https://github.com/folke/lazy.nvim)
- 🐛 New Bugs: Lots of new and exciting bugs to discover! 🐞

## Screenshots

**Classic Mode**
![image](https://github.com/folke/which-key.nvim/assets/292349/14195bd3-1015-4c44-81c6-4ef8f2410c1b)

**Modern Mode**
![image](https://github.com/folke/which-key.nvim/assets/292349/842e9311-ded9-458a-bed4-2b12f075c85f)

**Helix Mode**
![image](https://github.com/folke/which-key.nvim/assets/292349/ca553e0c-e92d-4968-9dce-de91601c5c5c)

For detailed configuration and usage instructions, refer to the updated README.
