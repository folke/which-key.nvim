command! -nargs=* WhichKey lua require('which-key').show_command(<f-args>)
au VimEnter * ++once lua require("which-key").load()
