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
---@field id string terminal codes for lhs
local Keymap

---@class KeyCodes
---@field keys string
---@field term string[]
---@field nvim string[]
local KeyCodes

---@class MappingOptions
---@field noremap boolean
---@field silent boolean
local MappingOptions

---@class Mapping
---@field buf number
---@field group boolean
---@field label string
---@field prefix string
---@field cmd string
---@field opts MappingOptions
---@field keys KeyCodes
local Mapping

---@class MappingTree
---@field mode string
---@field buf number
---@field tree Tree
local MappingTree

---@class VisualMapping : Mapping
---@field key string
local VisualMapping

