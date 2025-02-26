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
---@field loop? boolean
---@field defer? boolean don't show the popup immediately. Wait for the first key to be pressed
---@field waited? number
---@field check? boolean
---@field expand? boolean

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

--- Represents a node in the which-key tree
---@class wk.Node: wk.Mapping
---@field key string single key of the node
---@field path string[] path to the node (all keys leading to this node)
---@field keys string full key sequence
---@field parent? wk.Node parent node
---@field keymap? wk.Keymap Real keymap
---@field mapping? wk.Mapping Mapping info supplied by user
---@field action? fun() action to execute when node is selected (used by plugins)

---@class wk.Mapping: wk.Keymap
---@field idx? number
---@field plugin? string
---@field group? boolean
---@field remap? boolean
---@field hidden? boolean
---@field real? boolean this is a mapping for a real keymap. Hide it if the real keymap does not exist
---@field preset? boolean
---@field icon? wk.Icon|string
---@field proxy? string
---@field expand? fun():wk.Spec

---@class wk.Spec: {[number]: wk.Spec} , wk.Mapping
---@field [1]? string
---@field [2]? string|fun()
---@field lhs? string
---@field group? string|fun():string
---@field desc? string|fun():string
---@field icon? wk.Icon|string|fun():(wk.Icon|string)
---@field buffer? number|boolean
---@field mode? string|string[]
---@field cond? boolean|fun():boolean?

---@class wk.Win.opts: vim.api.keyset.win_config
---@field width? wk.Dim
---@field height? wk.Dim
---@field wo? vim.wo
---@field bo? vim.bo
---@field padding? {[1]: number, [2]:number}
---@field no_overlap? boolean

---@class wk.Col
---@field key string
---@field hl? string
---@field width? number
---@field padding? number[]
---@field default? string
---@field align? "left"|"right"|"center"

---@class wk.Table.opts
---@field cols wk.Col[]
---@field rows table<string, string>[]

---@class wk.Plugin.item
---@field key string
---@field value string
---@field desc string
---@field order? number
---@field action? fun()

---@class wk.Plugin
---@field name string
---@field cols? wk.Col[]
---@field mappings? wk.Spec
---@field expand fun():wk.Plugin.item[]
---@field setup fun(opts: table<string, any>)

---@class wk.Item: wk.Node
---@field node wk.Node
---@field key string
---@field raw_key string
---@field desc string
---@field group? boolean
---@field order? number
---@field icon? string
---@field icon_hl? string
