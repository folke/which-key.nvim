---@meta

--# selene: allow(unused_variable)

---@class wk.Filter
---@field mode? string
---@field buf? number
---@field keys? string
---@field global? boolean
---@field local? boolean
---@field update? boolean
---@field delay? number

---@class wk.Icon
---@field icon? string
---@field hl? string
---@field cat? "file" | "filetype" | "extension"
---@field name? string
---@field color? false | "azure" | "blue" | "cyan" | "green" | "grey" | "orange" | "purple" | "red" | "yellow"

---@class wk.IconProvider
---@field name string
---@field available? boolean
---@field get fun(icon: wk.Icon):(icon: string?, hl: string?)

---@class wk.IconRule: wk.Icon
---@field pattern? string
---@field plugin? string

---@class wk.Keymap: vim.api.keyset.keymap
---@field lhs string
---@field mode string
---@field rhs? string|fun()
---@field lhsraw? string
---@field buffer? number

---@class wk.Mapping: wk.Keymap
---@field idx? number
---@field plugin? string
---@field group? boolean
---@field remap? boolean
---@field hidden? boolean
---@field preset? boolean
---@field icon? wk.Icon|string

---@class wk.Spec: {[number]: wk.Spec} , wk.Mapping
---@field [1]? string|fun()
---@field [2]? string
---@field lhs? string
---@field group? string
---@field mode? string|string[]
---@field cond? boolean|fun():boolean?

---@class wk.Win: vim.api.keyset.win_config
---@field width? wk.Size
---@field height? wk.Size
---@field wo? vim.wo
---@field bo? vim.bo
---@field padding? {[1]: number, [2]:number}

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
