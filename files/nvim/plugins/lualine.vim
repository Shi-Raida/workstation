lua << END
require('lualine').setup {
    options = {
        theme = 'dracula',
        refresh = {
            statusline = 500,
            tabline = 500,
            winbar = 500,
        }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
}
END
