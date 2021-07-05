require("preset.normal")
require("preset.insert")
require("preset.visual")
require("preset.command-line")
require("preset.operator-pending")
--[[

extra:
- excludes mousebinds
- excludes the <C-...> binds in windows mode that are all "same as"
- normalbinds exclude motions and operators
   (this also excludes text objects, registers, and marks)
- does not show symbols/indictators for keybinds that expect a char (ex. `f`)
- descriptions are not completely true to source (vim index)

--]]
