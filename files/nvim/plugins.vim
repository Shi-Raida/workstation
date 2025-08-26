call plug#begin('~/.vim/plugged')

    " Theme
    Plug 'dracula/vim', { 'as': 'dracula' }
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " Status bar
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'kyazdani42/nvim-web-devicons'

    " Smooth scrolling
    Plug 'psliwka/vim-smoothie'

    " i3
    Plug 'mboughaba/i3config.vim'

call plug#end()
