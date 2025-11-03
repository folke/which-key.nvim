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
  { pattern = "%f[%a]git", cat = "filetype", name = "git" },
  { pattern = "test", cat = "filetype", name = "neotest-summary" },
  { pattern = "lazy", cat = "filetype", name = "lazy" },

  { icon = "⚡", pattern = "profiler", color = "orange" },
  { icon = " ", pattern = "window", color = "blue" },
  { icon = "󱖫 ", pattern = "diagnostic", color = "green" },
  { icon = "󱖫 ", pattern = "quickfix", color = "green" },
  { icon = "󱖫 ", pattern = "location list", color = "green" },
  { icon = " ", pattern = "format", color = "cyan" },
  { icon = "󰨰 ", pattern = "debug", color = "red" },
  { icon = " ", pattern = "code", color = "orange" },
  { icon = "󰵅 ", pattern = "notif", color = "blue" },
  { icon = " ", pattern = "toggle", color = "yellow" },
  { icon = " ", pattern = "session", color = "azure" },
  { icon = "󰓩 ", pattern = "tab", color = "purple" },
  { icon = " ", pattern = "icon", color = "yellow" },
  { icon = "󰙵 ", pattern = "%f[%a]ui", color = "cyan" },

  { icon = "󱙺 ", pattern = "%f[%a]ai", color = "azure" },
  { icon = " ", pattern = "copilot", color = "azure" },

  { icon = "󰈆 ", pattern = "exit", color = "red" },
  { icon = "󰈆 ", pattern = "quit", color = "red" },

  { icon = " ", pattern = "color", color = "azure" },
  { icon = " ", pattern = "highlight", color = "azure" },

  -- Commands, Memory, History
  { icon = " ", pattern = "terminal", color = "orange" },
  { icon = " ", pattern = "command", color = "orange" },
  { icon = " ", pattern = "cmd", color = "orange" },
  { icon = " ", pattern = "keymap", color = "orange" },
  { icon = "󰜎 ", pattern = "jump", color = "orange" },
  { icon = "󰙅 ", pattern = "undotree", color = "orange" },
  { icon = " ", pattern = "register", color = "orange" },
  { icon = "󰃃 ", pattern = "mark", color = "orange" },
  { icon = "󰅌 ", pattern = "yank", color = "orange" },
  { icon = "󰅌 ", pattern = "clipboard", color = "orange" },

  -- Search
  { icon = "󰘥 ", pattern = "%f[%a]help", color = "green" },
  { icon = "󰘥 ", pattern = "%f[%a]man", color = "green" },
  { icon = "󰘥 ", pattern = "%f[%a]keywordprg", color = "green" },
  { icon = "󱩾 ", pattern = "resume", color = "green" },
  { icon = "󱩾 ", pattern = "grep", color = "green" },
  { icon = " ", pattern = "find", color = "green" },
  { icon = " ", pattern = "search", color = "green" },
  { icon = "󱈅 ", pattern = "visual selection", color = "green" },

  -- Files
  { icon = "󰻭 ", pattern = "%f[%a]new", color = "cyan" },
  { icon = "󱋢 ", pattern = "recent", color = "cyan" },
  { icon = "󰪻 ", pattern = "project", color = "cyan" },
  { icon = "󰧮 ", pattern = "buffer", color = "cyan" },
  { icon = "󰈤 ", pattern = "file", color = "cyan" },

  -- Plugins
  { icon = "󱅻 ", plugin = "zen-mode.nvim", color = "cyan" },
  { icon = " ", plugin = "telescope.nvim", pattern = "telescope", color = "blue" },
  { icon = "󰛢 ", plugin = "grapple.nvim", pattern = "grapple", color = "azure" },
  { icon = "󰛔 ", plugin = "nvim-spectre", color = "blue" },
  { icon = "󰛔 ", plugin = "grug-far.nvim", pattern = "grug", color = "blue" },
  { icon = "󰈸 ", plugin = "noice.nvim", pattern = "noice", color = "orange" },
  { icon = " ", plugin = "persistence.nvim", color = "azure" },
  { icon = "󱥰 ", plugin = "snacks.nvim", color = "purple" },
  { icon = " ", plugin = "refactoring.nvim", pattern = "refactor", color = "cyan" },
  { plugin = "fzf-lua", cat = "filetype", name = "fzf" },
  { plugin = "neo-tree.nvim", cat = "filetype", name = "neo-tree" },
  { plugin = "octo.nvim", cat = "filetype", name = "git" },
  { plugin = "trouble.nvim", cat = "filetype", name = "trouble" },
  { plugin = "todo-comments.nvim", cat = "file", name = "TODO" },
  { plugin = "neotest", cat = "filetype", name = "neotest-summary" },
  { plugin = "lazy.nvim", cat = "filetype", name = "lazy" },
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
