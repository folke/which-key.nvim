local Buf = require("which-key.buf")
local Config = require("which-key.config")
local Icons = require("which-key.icons")
local Tree = require("which-key.tree")

local M = {}

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error
local info = vim.health.info or vim.health.report_info

-- TODO: Add more checks
-- * duplicate desc
-- * mapping.desc ~= keymap.desc
-- * check for old-style mappings

function M.check()
  ok(
    "Most of these checks are for informational purposes only.\n"
      .. "WARNINGS should be treated as a warning, and don't necessarily indicate a problem with your config.\n"
      .. "Please |DON't| report these warnings as an issue."
  )
  local have_icons = false
  for _, provider in ipairs(Icons.providers) do
    if provider.available == nil then
      provider.available = pcall(require, provider.name)
    end
    if provider.available then
      ok("|" .. provider.name .. "| is installed")
      have_icons = true
    else
      warn("|" .. provider.name .. "| is not installed")
    end
  end
  if not have_icons then
    warn("Keymap icon support will be limited.")
  end

  start("checking for overlapping keymaps")
  local found = false

  Buf.cleanup()

  ---@type table<string, boolean>
  local reported = {}

  for _, buf in pairs(Buf.bufs) do
    for mapmode in pairs(Config.modes) do
      local mode = buf:get({ mode = mapmode })
      if mode then
        mode.tree:walk(function(node)
          local km = node.keymap
          if not km or km.rhs == "" or km.rhs == "<Nop>" or node.keys:sub(1, 6) == "<Plug>" then
            return
          end
          if node.keymap and Tree.is_group(node) then
            local id = mode.mode .. ":" .. node.keys
            if reported[id] then
              return
            end
            reported[id] = true
            local overlaps = {}
            local descs = {}
            if node.desc and node.desc ~= "" then
              descs[#descs + 1] = "- <" .. node.keys .. ">: " .. node.desc
            end
            local queue = vim.tbl_values(node.children)
            while #queue > 0 do
              local child = table.remove(queue)
              if child.keymap then
                table.insert(overlaps, "<" .. child.keys .. ">")
                if child.desc and child.desc ~= "" then
                  descs[#descs + 1] = "- <" .. child.keys .. ">: " .. child.desc
                end
              end
              vim.list_extend(queue, vim.tbl_values(child.children or {}))
            end
            if #overlaps > 0 then
              found = true
              warn(
                "In mode `"
                  .. mode.mode
                  .. "`, <"
                  .. node.keys
                  .. "> overlaps with "
                  .. table.concat(overlaps, ", ")
                  .. ":\n"
                  .. table.concat(descs, "\n")
              )
            end
            return false
          end
        end)
      end
    end
  end

  if found then
    ok(
      "Overlapping keymaps are only reported for informational purposes.\n"
        .. "This doesn't necessarily mean there is a problem with your config."
    )
  else
    ok("No overlapping keymaps found")
  end

  start("Checking for duplicate mappings")

  if vim.tbl_isempty(Tree.dups) then
    ok("No duplicate mappings found")
  else
    for _, mappings in pairs(Tree.dups) do
      ---@type wk.Mapping[]
      mappings = vim.tbl_keys(mappings)
      local first = mappings[1]
      warn(
        "Duplicates for <"
          .. first.lhs
          .. "> in mode `"
          .. first.mode
          .. "`:\n"
          .. table.concat(
            vim.tbl_map(function(m)
              m = vim.deepcopy(m)
              local desc = (m.desc and (m.desc .. ": ") or "")
              m.desc = nil
              m.idx = nil
              m.mode = nil
              m.lhs = nil
              return "* " .. desc .. "`" .. vim.inspect(m):gsub("%s+", " ") .. "`"
            end, mappings),
            "\n"
          )
      )
    end
    ok(
      "Duplicate mappings are only reported for informational purposes.\n"
        .. "This doesn't necessarily mean there is a problem with your config."
    )
  end
end

return M
