local Config = require("which-key.config")

local M = {}

--- * `MiniIconsAzure`  - azure.
--- * `MiniIconsBlue`   - blue.
--- * `MiniIconsCyan`   - cyan.
--- * `MiniIconsGreen`  - green.
--- * `MiniIconsGrey`   - grey.
--- * `MiniIconsOrange` - orange.
--- * `MiniIconsPurple` - purple.
--- * `MiniIconsRed`    - red.
--- * `MiniIconsYellow` - yellow.

---@type wk.IconRule[]
M.rules = {
  { plugin = "fzf-lua", cat = "filetype", name = "fzf" },
  { plugin = "neo-tree.nvim", cat = "filetype", name = "neo-tree" },
  { plugin = "octo.nvim", cat = "filetype", name = "git" },
  { plugin = "yanky.nvim", icon = "󰅇", hl = "MiniIconsYellow" },
  { plugin = "zen-mode.nvim", icon = "󱅻 ", hl = "MiniIconsCyan" },
  { plugin = "trouble.nvim", cat = "filetype", name = "trouble" },
  { plugin = "todo-comments.nvim", cat = "file", name = "TODO" },
  { plugin = "nvim-spectre", icon = "󰛔 ", hl = "MiniIconsBlue" },
  { plugin = "noice.nvim", pattern = "noice", icon = "󰈸", hl = "MiniIconsOrange" },
  { plugin = "persistence.nvim", icon = " ", hl = "MiniIconsAzure" },
  { plugin = "neotest", cat = "filetype", name = "neotest-summary" },
  { plugin = "lazy.nvim", cat = "filetype", name = "lazy" },
  { plugin = "CopilotChat.nvim", icon = " ", hl = "MiniIconsOrange" },
  { pattern = "git", cat = "filetype", name = "git" },
  { pattern = "terminal", icon = " ", hl = "MiniIconsRed" },
  { pattern = "find", icon = " ", hl = "MiniIconsGreen" },
  { pattern = "search", icon = " ", hl = "MiniIconsGreen" },
  { pattern = "test", cat = "filetype", name = "neotest-summary" },
  { pattern = "lazy", cat = "filetype", name = "lazy" },
  { pattern = "buffer", icon = "󰈔", hl = "MiniIconsCyan" },
  { pattern = "file", icon = "󰈔", hl = "MiniIconsCyan" },
  { pattern = "window", icon = " ", hl = "MiniIconsBlue" },
  { pattern = "diagnostic", icon = "󱖫 ", hl = "MiniIconsGreen" },
  { pattern = "format", icon = " ", hl = "MiniIconsCyan" },
  { pattern = "debug", icon = "󰃤 ", hl = "MiniIconsRed" },
  { pattern = "code", icon = " ", hl = "MiniIconsOrange" },
  { pattern = "notif", icon = "󰵅 ", hl = "MiniIconsBlue" },
  { pattern = "toggle", icon = " ", hl = "MiniIconsYellow" },
  { pattern = "exit", icon = "󰈆 ", hl = "MiniIconsRed" },
  { pattern = "quit", icon = "󰈆 ", hl = "MiniIconsRed" },
  { pattern = "tab", icon = "󰓩 ", hl = "MiniIconsPurple" },
  { pattern = "ai", icon = " ", hl = "MiniIconsGreen" },
  { pattern = "ui", icon = "󰙵 ", hl = "MiniIconsCyan" },
}

---@module 'mini.icons'
local Icons
local loaded = false

local function load()
  if not loaded then
    _, Icons = pcall(require, "mini.icons")
    loaded = true
  end
  return Icons ~= nil
end

---@param icon wk.Icon|string
---@return string?, string?
function M.get_icon(icon)
  icon = type(icon) == "string" and { cat = "filetype", name = icon } or icon --[[@as wk.Icon]]
  if icon.icon then
    return icon.icon, icon.hl
  end
  if icon.cat and icon.name and load() then
    local ico, ico_hl, ico_def = Icons.get(icon.cat, icon.name) --[[@as string, string, boolean]]
    if not ico_def then
      return ico, ico_hl
    end
  end
end

---@param rules wk.IconRule[]
---@param opts? {keymap?: wk.Keymap, desc?: string, ft?:string|string[]}|wk.Icon
---@param check_ft? boolean
---@return string?, string?
function M._get(rules, opts, check_ft)
  opts = opts or {}
  opts.ft = type(opts.ft) == "string" and { opts.ft } or opts.ft

  ---@type string?
  local plugin
  local fts = opts.ft or {} --[[@as string[] ]]

  if opts.keymap and package.loaded.lazy then
    local LazyUtil = require("lazy.core.util")
    local Keys = require("lazy.core.handler").handlers.keys --[[@as LazyKeysHandler]]
    local keys = Keys.parse(opts.keymap.lhs, opts.keymap.mode)
    plugin = Keys.managed[keys.id]
    if plugin then
      fts[#fts + 1] = LazyUtil.normname(plugin)
    end
  end

  -- plugin icons
  if plugin then
    for _, icon in ipairs(rules) do
      if icon.plugin == plugin then
        return M.get_icon(icon)
      end
    end
  end

  -- filetype icons
  if check_ft then
    if opts.keymap and opts.keymap.buffer and opts.keymap.buffer ~= 0 then
      pcall(function()
        fts[#fts + 1] = vim.bo[opts.keymap.buffer].filetype
      end)
    end
    for _, ft in ipairs(fts) do
      local icon, hl = M.get_icon({ cat = "filetype", name = ft })
      if icon then
        return icon, hl
      end
    end
  end

  -- pattern icons
  if opts.desc then
    for _, icon in ipairs(rules) do
      if icon.pattern and opts.desc:lower():find(icon.pattern) then
        return M.get_icon(icon)
      end
    end
  end

  return M.get_icon(opts)
end

---@param opts? {keymap?: wk.Keymap, desc?: string, ft?:string|string[]}|wk.Icon
function M.get(opts)
  if Config.icons.rules == false then
    return
  end
  local icon, hl = M._get(Config.icons.rules, opts)
  if icon then
    return icon, hl
  end

  return M._get(M.rules, opts, true)
end

return M
