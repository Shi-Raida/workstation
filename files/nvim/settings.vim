" Leader
let mapleader=","

" Show relative line number
set relativenumber

" Clipboard
set clipboard=unnamedplus

" Tab
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set smarttab

" Split panes to bottom and right
set splitbelow
set splitright

" Cursor config
set termguicolors
set cursorline
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175

" Fast saving
nmap <leader>w <CMD>w!<CR>

" Fast quit
nmap <leader>q <CMD>q<CR>
nmap <C-Q> <CMD>q!<CR>

" :W sudo saves the file
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!
