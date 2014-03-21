set nocompatible	          " Use Vim defaults, not vi

set encoding=utf-8                " Set default encoding to UTF-8
set backspace=eol,start,indent    " backspace through everything in insert mode
syntax on


""
"" Backup and swap files (taken from Janus)
""

set backupdir^=~/.vim/_backup//    " where to put backup files.
set directory^=~/.vim/_temp//      " where to put swap files.
