local M = {}

---@type table<string, fun():wk.Spec>
M.expand = {}

---@return number[]
function M.bufs()
  local current = vim.api.nvim_get_current_buf()
  return vim.tbl_filter(function(buf)
    return buf ~= current and vim.bo[buf].buflisted
  end, vim.api.nvim_list_bufs())
end

function M.bufname(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  return name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":~:.")
end

---@param spec wk.Spec[]
function M.add_keys(spec)
  table.sort(spec, function(a, b)
    return a.desc < b.desc
  end)
  spec = vim.list_slice(spec, 1, 10)
  for i, v in ipairs(spec) do
    v[1] = tostring(i - 1)
  end
  return spec
end

function M.expand.buf()
  local ret = {} ---@type wk.Spec[]

  for _, buf in ipairs(M.bufs()) do
    local name = M.bufname(buf)
    ret[#ret + 1] = {
      "",
      function()
        vim.api.nvim_set_current_buf(buf)
      end,
      desc = name,
      icon = { cat = "file", name = name },
    }
  end
  return M.add_keys(ret)
end

function M.expand.win()
  ---@type wk.Spec[]
  local ret = {}
  local current = vim.api.nvim_get_current_win()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local is_float = vim.api.nvim_win_get_config(win).relative ~= ""
    if win ~= current and not is_float then
      local buf = vim.api.nvim_win_get_buf(win)
      local name = M.bufname(buf)
      ret[#ret + 1] = {
        "",
        function()
          vim.api.nvim_set_current_win(win)
        end,
        desc = name,
        icon = { cat = "file", name = name },
      }
    end
  end
  return M.add_keys(ret)
end

return M
