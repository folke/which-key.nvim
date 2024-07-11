---@meta

--# selene: allow(unused_variable)

---@class wk.Filter
---@field mode? string
---@field buf? number
---@field keys? string
---@field global? boolean
---@field local? boolean
---@field update? boolean

---@class wk.Icon
---@field icon? string
---@field hl? string
---@field cat? string
---@field name? string

---@class wk.IconRule: wk.Icon
---@field pattern? string
---@field plugin? string

---@class wk.Keymap: vim.api.keyset.keymap
---@field lhs string
---@field idx? number
---@field mode string
---@field rhs? string
---@field lhsraw? string
---@field buffer? number
---@field plugin? string
---@field group? boolean
---@field virtual? boolean
---@field hidden? boolean

---@class wk.Win: vim.api.keyset.win_config
---@field width? wk.Size
---@field height? wk.Size
---@field wo? vim.wo
---@field bo? vim.bo
---@field padding? {[1]: number, [2]:number}

---@class MappingOptions
---@field noremap boolean
---@field silent boolean
---@field nowait boolean
---@field expr boolean

---@class Mapping
---@field buf number
---@field group boolean
---@field desc string
---@field prefix string
---@field cmd string
---@field opts MappingOptions
---@field mode? string
---@field callback fun()|nil
---@field preset boolean
---@field plugin string
---@field fn fun()

---@class wk.Plugin.item
---@field key string
---@field value string
---@field desc string
---@field order? number
---@field action? fun()

---@class wk.Plugin.action
---@field trigger string
---@field mode string
---@field label? string
---@field delay? boolean

---@class wk.Plugin
---@field name string
---@field cols? wk.Col[]
---@field actions wk.Plugin.action[]
---@field expand fun():wk.Plugin.item[]
---@field setup fun(opts: table<string, any>)
