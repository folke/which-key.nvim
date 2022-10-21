---@meta

--# selene: allow(unused_variable)

---@class Keymap
---@field rhs string
---@field lhs string
---@field buffer number
---@field expr number
---@field lnum number
---@field mode string
---@field noremap number
---@field nowait number
---@field script number
---@field sid number
---@field silent number
---@field callback fun()|nil
---@field id string terminal keycodes for lhs
---@field desc string

---@class KeyCodes
---@field keys string
---@field internal string[]
---@field notation string[]

---@class MappingOptions
---@field noremap boolean
---@field silent boolean
---@field nowait boolean
---@field expr boolean

---@class Mapping
---@field buf number
---@field group boolean
---@field label string
---@field desc string
---@field prefix string
---@field cmd string
---@field opts MappingOptions
---@field keys KeyCodes
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
