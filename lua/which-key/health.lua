local Buf = require("which-key.buf")
local Config = require("which-key.config")
local Icons = require("which-key.icons")
local Mappings = require("which-key.mappings")
local Migrate = require("which-key.migrate")
local Tree = require("which-key.tree")
local Util = require("which-key.util")

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
      .. "Please |DON'T| report these warnings as an issue."
  )

  start("Checking your config")

  if #Config.issues > 0 then
    local msg = {
      "There are issues with your config:",
    }
    vim.list_extend(
      msg,
      vim.tbl_map(function(issue)
        return "- `opts." .. issue.opt .. "`: " .. issue.msg
      end, Config.issues)
    )
    msg[#msg + 1] = "Please refer to the docs for more info."
    warn(table.concat(msg, "\n"))
  end

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

  start("Checking for issues with your mappings")
  if #Mappings.notifs == 0 then
    ok("No issues reported")
  end
  for _, notif in ipairs(Mappings.notifs) do
    local msg = notif.msg
    if notif.spec then
      msg = msg .. ": >\n" .. vim.inspect(notif.spec)
      if msg:find("old version") then
        local fixed = Migrate.migrate(notif.spec)
        msg = msg .. "\n\n-- Suggested Spec:\n" .. fixed
      end
    end
    (notif.level >= vim.log.levels.ERROR and error or warn)(msg)
  end

  start("checking for overlapping keymaps")
  local found = false

  Buf.cleanup()

  ---@type table<string, boolean>
  local reported = {}

  local mapmodes = vim.split("nixsotc", "")

  for _, buf in pairs(Buf.bufs) do
    for _, mapmode in ipairs(mapmodes) do
      local mode = buf:get({ mode = mapmode })
      if mode then
        mode.tree:walk(function(node)
          local km = node.keymap
          if not km or Util.is_nop(km.rhs) or node.keys:sub(1, 6) == "<Plug>" then
            return
          end
          if node.keymap and node:count() > 0 then
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
            local queue = node:children()
            while #queue > 0 do
              local child = table.remove(queue)
              if child.keymap then
                table.insert(overlaps, "<" .. child.keys .. ">")
                if child.desc and child.desc ~= "" then
                  descs[#descs + 1] = "- <" .. child.keys .. ">: " .. child.desc
                end
              end
              vim.list_extend(queue, child:children())
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
