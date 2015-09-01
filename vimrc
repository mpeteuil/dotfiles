call plug#begin('~/.nvim/plugged')

"" Colors
Plug 'tomasr/molokai'
Plug 'junegunn/seoul256.vim'

"" Other plugins
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'wting/rust.vim', { 'for': 'rust' }
Plug 'rking/ag.vim'

Plug 'mustache/vim-mustache-handlebars'

call plug#end()


""
"" Basic Setup
""

syntax on
set number                        " Show line numbers
set relativenumber                " Make line numbers relative
set ruler                         " Show line and column number
set encoding=utf-8                " Set default encoding to UTF-8
set path=**
set cursorline

let g:netrw_banner=0                        " Hide netrw help
let &colorcolumn=join(range(80,999),",")    " Highlight past 79 characters

""
"" Leader mappings
""

let mapleader = ","

"" Open new tab with .vimrc
noremap <Leader>vi :tabe ~/.nvimrc<cr>

"" Open new tab exploring the current directory
noremap <Leader>nt :tabe .<cr>

"" Restart processes that use tmp/restart.txt
noremap <Leader>re :!touch tmp/restart.txt<cr>

"" Bundle install
noremap <Leader>bi :!bundle<cr>

"" Install new plugins
nnoremap <Leader>pi :source ~/.nvimrc<cr>:PlugClean<cr>:PlugInstall<cr>
nnoremap <Leader>ps :source ~/.nvimrc<cr>:PlugStatus<cr>

nnoremap <Leader>vs :source ~/.nvimrc<cr>

"" Search
noremap <Leader>f :FZF<cr>

"" Replace trailing whitespace
noremap <Leader>rw :%s/\s\+$//<cr>


"" Resize viewports (experimental)

" Left
nnoremap <c-h> :vertical resize -5<CR>
" Right
nnoremap <c-l> :vertical resize +5<CR>
" Up
nnoremap <c-k> :resize +5<CR>
" Down
nnoremap <c-j> :resize -5<CR>

" Cycle through tabs
nnoremap <s-f> :tabnext<cr>
nnoremap <s-s> :tabprev<cr>

"" Ag
nnoremap <Leader>k :Ag<space>

"" Generate ctags
nnoremap <Leader>ct :!ctags -R --tag-relative=yes --exclude=".git" --exclude=".bundle" .<cr>

"" Use Ag for searching
if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor\ --column\ --smart-case
  set grepformat=%f:%l:%c:%m

  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

""
"" Colorscheme
""

set t_Co=256
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
"" Auto-commands
""

if has("autocmd")
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,Guardfile,config.ru,*.rake,*.thor,*.jbuilder} set ft=ruby
endif


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
