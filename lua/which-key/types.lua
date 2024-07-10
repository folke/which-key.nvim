---@meta

--# selene: allow(unused_variable)

---@class wk.Keymap: vim.api.keyset.keymap
---@field lhs string
---@field mode string
---@field rhs? string
---@field lhsraw? string
---@field buffer? number
---@field plugin? string
---@field group? boolean
---@field virtual? boolean

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
