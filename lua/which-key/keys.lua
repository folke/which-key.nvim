local M = {}

function M.t(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

function M.parse_keys(keystr)
  local keys = {}
  local special = nil
  for i = 1, #keystr, 1 do
    local c = keystr:sub(i, i)
    if c == "<" then
      special = "<"
    elseif c == ">" and special then
      table.insert(keys, special .. ">")
      special = nil
    elseif special then
      special = special .. c
    else
      table.insert(keys, c)
    end
  end
  local ret = { keys = M.t(keystr), term = {}, nvim = {} }
  for i, key in pairs(keys) do
    if key == " " then key = "<space>" end
    if i == 1 and vim.g.mapleader and M.t(key) == M.t(vim.g.mapleader) then key = "<leader>" end
    table.insert(ret.term, M.t(key))
    table.insert(ret.nvim, key)
  end
  return ret
end

function M.get_keymap(mode, prefix, buf)
  local mappings = {}

  local key_count = #M.parse_keys(prefix).nvim

  local map = function(keymap)
    prefix = M.t(prefix)
    for _, mapping in pairs(keymap) do
      local id = M.t(mapping.lhs)
      if id:sub(1, #prefix) == prefix then
        mapping.id = id
        local idx = M.get_idx(mode, mapping.id)
        local buf_idx = M.get_idx(mode, mapping.id, buf)
        mapping.keys = M.parse_keys(mapping.lhs)
        mapping = vim.tbl_deep_extend("force", {}, mapping, M.mappings[idx] or {},
                                      M.mappings[buf_idx] or {}, mapping)
        mappings[id] = mapping
      end
    end
  end

  -- global mappings
  map(vim.api.nvim_get_keymap(mode))
  -- buffer local mappings
  if buf then map(vim.api.nvim_buf_get_keymap(buf, mode)) end

  local ret = {}
  for _, value in pairs(mappings) do table.insert(ret, value) end

  table.sort(ret, function(a, b)
    if a.group == b.group then
      return (a.keys.nvim[key_count + 1] or "") < (b.keys.nvim[key_count + 1] or "")
    else
      return (a.group and 1 or 0) < (b.group and 1 or 0)
    end
  end)

  return ret
end

function M.parse_mappings(ret, value, prefix)
  prefix = prefix or ""
  if type(value) == "string" then
    table.insert(ret, { prefix = prefix, label = value })
  elseif type(value) == "table" then
    if #value == 0 then
      -- key group
      for k, v in pairs(value) do if k ~= "name" then M.parse_mappings(ret, v, prefix .. k) end end
      if prefix ~= "" then
        table.insert(ret, { prefix = prefix, label = value.name or "+prefix", group = true })
      end
    else
      -- key mapping
      local mapping = { prefix = prefix, opts = {} }
      for k, v in pairs(value) do
        if k == 1 then
          mapping.label = v
        elseif k == 2 then
          mapping.cmd = mapping.label
          mapping.label = v
        elseif k == "noremap" then
          mapping.opts.noremap = v
        elseif k == "silent" then
          mapping.opts.silent = v
        elseif k == "bufnr" then
          mapping.opts.bufnr = v
        else
          error("Invalid key mapping: " .. vim.inspect(value))
        end
      end
      table.insert(ret, mapping)
    end
  else
    error("Invalid mapping " .. vim.inspect(value))
  end
  return ret
end

M.mappings = {}

function M.register(mappings, opts)
  opts = opts or {}

  local prefix = opts.prefix or ""
  opts.prefix = nil

  local mode = opts.mode or "n"
  opts.mode = nil

  mappings = M.parse_mappings({}, mappings, prefix)

  for _, mapping in pairs(mappings) do
    mapping.id = M.t(mapping.prefix)
    mapping.opts = vim.tbl_deep_extend("force", { silent = true, noremap = true }, opts,
                                       mapping.opts or {})
    local cmd = mapping.cmd
    if mapping.group then
      mapping.opts.noremap = false
      cmd = string.format([[<cmd>lua require("which-key.view").on_keys(%q)<cr>]], mapping.prefix)
    end

    if cmd then
      if mapping.opts.bufnr ~= nil then
        local buf = mapping.opts.bufnr
        mapping.opts.bufnr = nil
        vim.api.nvim_buf_set_keymap(buf, mode, mapping.prefix, cmd, mapping.opts)
        mapping.opts.bufnr = buf
      else
        vim.api.nvim_set_keymap(mode, mapping.prefix, cmd, mapping.opts)
      end
    end
    local idx = M.get_idx(mode, mapping.id, mapping.opts.bufnr)
    M.mappings[idx] = vim.tbl_deep_extend("force", M.mappings[idx] or {}, mapping)
  end
end

function M.get_idx(mode, keyid, buf)
  local ret = mode .. ":" .. keyid
  if buf then ret = ":" .. buf end
  return ret
end

return M
