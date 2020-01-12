"Vim config file

"Enable syntax highlighting
syntax on

"Enable backspace in insert mode
set backspace=indent,eol,start

"Disable backup files
set nobackup
set nowritebackup
set noswapfile

"Disable viminfo
set viminfo=

"Show lines of context whilst scrolling
set scrolloff=5

"Print final line that doesn't fit in window
set display=lastline

"Display right magin at 80 chars
set colorcolumn=80

"Increase max number of tabs
set tabpagemax=30

"Disable bell sounds
set belloff=all

"Set tabstop options for new files
autocmd BufNewFile * :set sw=4 ts=8 sts=0 et noai
