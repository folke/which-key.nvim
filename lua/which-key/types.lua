---@meta

--# selene: allow(unused_variable)

---@class wk.Keymap: vim.api.keyset.keymap
---@field lhs string
---@field mode string
---@field rhs? string
---@field lhsraw? string
---@field buffer? number
---@field group? boolean

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

---@class MappingTree
---@field mode string
---@field buf? number
---@field tree Tree

---@class VisualMapping : Mapping
---@field key string
---@field highlights table
---@field value string

---@class PluginItem
---@field key string
---@field label string
---@field value string
---@field cmd string
---@field highlights table

---@class PluginAction
---@field trigger string
---@field mode string
---@field label? string
---@field delay? boolean

---@class Plugin
---@field name string
---@field actions PluginAction[]
---@field run fun(trigger:string, mode:string, buf:number):PluginItem[]
---@field setup fun(wk, opts, Options)
