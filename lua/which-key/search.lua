local Buf = require("which-key.buf")

local M = {}

---@class wk.Search.item
---@field keys string the raw lhs key sequence used to execute the mapping
---@field display string formatted key sequence (with icons/symbols)
---@field desc string searchable description, prefixed with parent groups
---@field mode string

--- Returns the description for a node, falling back to its rhs.
---@param node wk.Node
---@return string?
local function desc_of(node)
  local desc = node.desc
  if not desc and node.keymap and type(node.keymap.rhs) == "string" and node.keymap.rhs ~= "" then
    desc = node.keymap.rhs --[[@as string]]
  end
  return desc
end

--- Builds the breadcrumb of parent group descriptions, e.g. "git → commit".
---@param node wk.Node
local function breadcrumb(node)
  local groups = {} ---@type string[]
  local parent = node.parent
  while parent and parent.parent do
    local d = parent.desc
    if d then
      table.insert(groups, 1, d)
    end
    parent = parent.parent
  end
  return groups
end

--- Collects all executable keymaps for the given mode as searchable items.
---@param mode wk.Mode
---@return wk.Search.item[]
local function collect(mode)
  local View = require("which-key.view")
  ---@type wk.Search.item[]
  local items = {}
  mode.tree:walk(function(node)
    -- only real, executable keymaps are searchable keybinds
    if not node.keymap then
      return
    end
    local desc = desc_of(node)
    local crumbs = breadcrumb(node)
    crumbs[#crumbs + 1] = desc or ""
    items[#items + 1] = {
      keys = node.keys,
      display = View.format(node.keys),
      desc = table.concat(crumbs, " → "),
      mode = mode.mode,
    }
  end)
  table.sort(items, function(a, b)
    if a.desc ~= b.desc then
      return a.desc < b.desc
    end
    return a.keys < b.keys
  end)
  return items
end

--- Executes the selected keymap by feeding its keys.
---@param item wk.Search.item
local function execute(item)
  local feed = vim.api.nvim_replace_termcodes(item.keys, true, true, true)
  vim.api.nvim_feedkeys(feed, "mt", false)
end

--- Fuzzy search keymaps by their description using `vim.ui.select`.
--- Picking an entry executes its keybind.
---@param opts? wk.Filter
function M.open(opts)
  opts = opts or {}
  local mode = Buf.get(opts)
  if not mode then
    require("which-key.util").warn("No keymaps found for mode `" .. (opts.mode or "n") .. "`")
    return
  end

  local items = collect(mode)
  if #items == 0 then
    require("which-key.util").warn("No keymaps found to search")
    return
  end

  -- align the key column for nicer formatting
  local width = 0
  for _, item in ipairs(items) do
    width = math.max(width, vim.fn.strdisplaywidth(item.display))
  end

  vim.ui.select(items, {
    prompt = "Search keymaps",
    kind = "which-key",
    ---@param item wk.Search.item
    format_item = function(item)
      local pad = string.rep(" ", width - vim.fn.strdisplaywidth(item.display))
      return item.display .. pad .. "  " .. item.desc
    end,
  }, function(item)
    if item then
      execute(item)
    end
  end)
end

return M
