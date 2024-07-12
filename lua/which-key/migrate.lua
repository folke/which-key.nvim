local Mappings = require("which-key.mappings")

local M = {}

---@param spec wk.Spec
function M.migrate(spec)
  spec = vim.deepcopy(spec)
  local mappings = Mappings.parse(spec, { version = 1, notify = false })
  ---@type table<string, {m:wk.Mapping, mode:string[]}>
  local mapping_modes = {}

  for _, m in ipairs(mappings) do
    m.preset = nil
    m[1] = m.lhs:gsub("<lt>", "<")
    m[2] = m.rhs
    m.lhs = nil
    m.rhs = nil
    local mode = m.mode
    m.mode = nil
    if m.silent then
      m.silent = nil
    end
    if m.group then
      m.group = m.desc
      m.desc = nil
    end
    local id = vim.inspect(m)
    mapping_modes[id] = mapping_modes[id] or { m = m, mode = {} }
    table.insert(mapping_modes[id].mode, mode)
  end

  mappings = vim.tbl_map(function(v)
    local m = v.m
    if not vim.deep_equal(v.mode, { "n" }) then
      m.mode = v.mode
    end
    return m
  end, vim.tbl_values(mapping_modes))

  table.sort(mappings, function(a, b)
    return a[1] < b[1]
  end)

  -- Group by modes
  ---@type table<string, wk.Mapping[]>
  local modes = {}
  for _, m in pairs(mappings) do
    local mode = m.mode or {}
    table.sort(mode)
    local id = table.concat(mode)
    modes[id] = modes[id] or {}
    table.insert(modes[id], m)
  end
  local lines = {}
  for mode, maps in pairs(modes) do
    if #maps > 2 and mode ~= "" then
      lines[#lines + 1] = "  {"
      lines[#lines + 1] = "    mode = " .. vim.inspect(maps[1].mode) .. ","
      for _, m in ipairs(maps) do
        m.mode = nil
        lines[#lines + 1] = "    " .. vim.inspect(m):gsub("%s+", " ") .. ","
      end
      lines[#lines + 1] = "  },"
    else
      for _, m in ipairs(maps) do
        if m.mode and #m.mode == 1 then
          m.mode = m.mode[1]
        end
        lines[#lines + 1] = "  " .. vim.inspect(m):gsub("%s+", " ") .. ","
      end
    end
  end

  return "{\n" .. table.concat(lines, "\n") .. "\n}"
end
return M
