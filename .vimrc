set nocompatible	          " Use Vim defaults, not vi
syntax on


""
"" Basic Setup
""

set number                        " Show line numbers
set relativenumber                " Make line numbers relative
set ruler                         " Show line and column number
set encoding=utf-8                " Set default encoding to UTF-8

let g:netrw_banner=0                        " Hide netrw help
let &colorcolumn=join(range(80,999),",")    " Highlight past 79 characters

""
"" Leader mappings
""

let mapleader = ","

"" Open new tab with .vimrc
noremap <Leader>vi :tabe ~/.vimrc<cr>

"" Open new tab exploring the current directory
noremap <Leader>nt :tabe .<cr>

"" Restart processes that use tmp/restart.txt
noremap <Leader>re :!touch tmp/restart.txt<cr>


"" Resize viewports (experimental)

" Left
nnoremap <Leader>a :vertical resize -5<CR>
" Right
nnoremap <Leader>f :vertical resize +5<CR>
" Up
nnoremap <Leader>d :resize +5<CR>
" Down
nnoremap <Leader>s :resize -5<CR>


""
"" Colorscheme
""

set t_Co=256
set term=xterm-256color
let g:molokai_original = 1
let g:rehash256 = 1
colorscheme molokai


""
"" Whitespace
""

set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode


""
"" List chars
""

set listchars=""                  " Reset the listchars
set listchars=tab:\ \             " a tab should display as \"  \", trailing whitespace as \".\"
set listchars+=trail:.            " show trailing spaces as dots
set listchars+=extends:>          " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the last column when wrap is
                                  " off and the line continues beyond the left of the screen


""
"" Searching
""

set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter


""
"" Backup and swap files (taken from Janus)
""

set backupdir^=~/.vim/_backup//    " where to put backup files.
set directory^=~/.vim/_temp//      " where to put swap files.


""
"" Ignores (mostly taken from Janus)
""

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Ignore rails temporary asset caches
set wildignore+=*/tmp/cache/assets/*/sprockets/*,*/tmp/cache/assets/*/sass/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*
