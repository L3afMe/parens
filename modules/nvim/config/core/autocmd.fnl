(import-macros {: augroup : autocmd} "macros")

(augroup :resume_edit_position
         [(autocmd "BufReadPost *"
                   "if line(\"'\\\"\") > 1 && line(\"'\\\"\") <= line(\"$\") && &ft !~# 'commit'"
                   "|execute \"normal! g`\\\"zvzz\" |"
                   "endif")])

(augroup :auto_read
         [(autocmd "FocusGained,BufEnter,CursorHold,CursorHoldI *"
                   "if mode() == 'n' && getcmdwintype() == ''"
                   "| checktime |"
                   "endif")
          (autocmd "FileChangedShellPost *"
                   "echohl WarningMsg |"
                   "echo \"File changed on disk. Buffer reloaded!\" |"
                   "echohl None")])

(augroup :number_toggle
         [(autocmd "BufEnter,FocusGained,InsertLeave,WinEnter *"
                   "if &nu"
                   "| set rnu |"
                   "endif")
          (autocmd "BufLeave,FocusLost,InsertEnter,WinLeave *"
                   "if &nu"
                   "| set nornu |"
                   "endif")])

(augroup :highlight_yank_color
         [(autocmd "ColorScheme *"
                   "highlight YankColor ctermfg=59 ctermbg=41 guifg=#34495E guibg=#2ECC71")])

(augroup :highlight_yank
         [(autocmd "TextYankPost *"
                   "silent! lua vim.highlight.on_yank{higroup=\"YankColor\", timeout=300}")])

