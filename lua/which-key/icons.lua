local Config = require("which-key.config")

local M = {}

--- * `WhichKeyColorAzure`  - azure.
--- * `WhichKeyColorBlue`   - blue.
--- * `WhichKeyColorCyan`   - cyan.
--- * `WhichKeyColorGreen`  - green.
--- * `WhichKeyColorGrey`   - grey.
--- * `WhichKeyColorOrange` - orange.
--- * `WhichKeyColorPurple` - purple.
--- * `WhichKeyColorRed`    - red.
--- * `WhichKeyColorYellow` - yellow.

---@type wk.IconRule[]
M.rules = {
  { plugin = "fzf-lua", cat = "filetype", name = "fzf" },
  { plugin = "neo-tree.nvim", cat = "filetype", name = "neo-tree" },
  { plugin = "octo.nvim", cat = "filetype", name = "git" },
  { plugin = "yanky.nvim", icon = "󰅇", color = "yellow" },
  { plugin = "zen-mode.nvim", icon = "󱅻 ", color = "cyan" },
  { plugin = "telescope.nvim", pattern = "telescope", icon = "", color = "blue" },
  { plugin = "trouble.nvim", cat = "filetype", name = "trouble" },
  { plugin = "todo-comments.nvim", cat = "file", name = "TODO" },
  { plugin = "grapple.nvim", pattern = "grapple", icon = "󰛢", color = "azure" },
  { plugin = "nvim-spectre", icon = "󰛔 ", color = "blue" },
  { plugin = "grug-far.nvim", pattern = "grug", icon = "󰛔 ", color = "blue" },
  { plugin = "noice.nvim", pattern = "noice", icon = "󰈸", color = "orange" },
  { plugin = "persistence.nvim", icon = " ", color = "azure" },
  { plugin = "neotest", cat = "filetype", name = "neotest-summary" },
  { plugin = "lazy.nvim", cat = "filetype", name = "lazy" },
  { plugin = "snacks.nvim", icon = "󱥰 ", color = "purple" },
  { plugin = "refactoring.nvim", pattern = "refactor", icon = " ", color = "cyan" },
  { pattern = "profiler", icon = "⚡", color = "orange" },
  { plugin = "CopilotChat.nvim", icon = " ", color = "orange" },
  { pattern = "%f[%a]git", cat = "filetype", name = "git" },
  { pattern = "terminal", icon = " ", color = "red" },
  { pattern = "find", icon = " ", color = "green" },
  { pattern = "search", icon = " ", color = "green" },
  { pattern = "test", cat = "filetype", name = "neotest-summary" },
  { pattern = "lazy", cat = "filetype", name = "lazy" },
  { pattern = "buffer", icon = "󰈔", color = "cyan" },
  { pattern = "file", icon = "󰈔", color = "cyan" },
  { pattern = "window", icon = " ", color = "blue" },
  { pattern = "diagnostic", icon = "󱖫 ", color = "green" },
  { pattern = "format", icon = " ", color = "cyan" },
  { pattern = "debug", icon = "󰃤 ", color = "red" },
  { pattern = "code", icon = " ", color = "orange" },
  { pattern = "notif", icon = "󰵅 ", color = "blue" },
  { pattern = "toggle", icon = " ", color = "yellow" },
  { pattern = "session", icon = " ", color = "azure" },
  { pattern = "exit", icon = "󰈆 ", color = "red" },
  { pattern = "quit", icon = "󰈆 ", color = "red" },
  { pattern = "tab", icon = "󰓩 ", color = "purple" },
  { pattern = "%f[%a]ai", icon = " ", color = "green" },
  { pattern = "ui", icon = "󰙵 ", color = "cyan" },
}

---@type wk.IconProvider[]
M.providers = {
  {
    name = "mini.icons",
    get = function(icon)
      local Icons = require("mini.icons")
      local ico, ico_hl, ico_def = Icons.get(icon.cat, icon.name) --[[@as string, string, boolean]]
      if not ico_def then
        return ico, ico_hl
      end
    end,
  },
  {
    name = "nvim-web-devicons",
    get = function(icon)
      local Icons = require("nvim-web-devicons")
      if icon.cat == "filetype" then
        return Icons.get_icon_by_filetype(icon.name, { default = false })
      elseif icon.cat == "file" then
        return Icons.get_icon(icon.name, nil, { default = false }) --[[@as string, string]]
      elseif icon.cat == "extension" then
        return Icons.get_icon(nil, icon.name, { default = false }) --[[@as string, string]]
      end
    end,
  },
}

---@return wk.IconProvider?
function M.get_provider()
  for _, provider in ipairs(M.providers) do
    if provider.available == nil then
      provider.available = pcall(require, provider.name)
    end
    if provider.available then
      return provider
    end
  end
end

function M.have()
  return M.get_provider() ~= nil
end

---@param icon wk.Icon|string
---@return string?, string?
function M.get_icon(icon)
  icon = type(icon) == "string" and { cat = "filetype", name = icon } or icon --[[@as wk.Icon]]
  ---@type string?, string?
  local ret, hl
  if icon.icon then
    ret, hl = icon.icon, icon.hl
  elseif icon.cat and icon.name then
    local provider = M.get_provider()
    if provider then
      ret, hl = provider.get(icon)
    end
  end
  if ret then
    if icon.color then
      hl = "WhichKeyIcon" .. icon.color:sub(1, 1):upper() .. icon.color:sub(2)
    end
    if not hl or Config.icons.colors == false or icon.color == false then
      hl = "WhichKeyIcon"
    end
    return ret, hl
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
        local ico, hl = M.get_icon(icon)
        if ico then
          return ico, hl
        end
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
        local ico, hl = M.get_icon(icon)
        if ico then
          return ico, hl
        end
      end
    end
  end
end

---@param opts {keymap?: wk.Keymap, desc?: string, ft?:string|string[]}|wk.Icon|string
function M.get(opts)
  if not Config.icons.mappings then
    return
  end
  if type(opts) == "string" then
    opts = { icon = opts }
  end

  if opts.icon or opts.cat then
    return M.get_icon(opts)
  end

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
