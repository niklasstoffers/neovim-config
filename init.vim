:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a
:set ma
:set termguicolors
:set t_Co=256
:syntax on

call plug#begin()

Plug 'ellisonleao/gruvbox.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'terrortylor/nvim-comment'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'kylechui/nvim-surround'
Plug 'smoka7/hydra.nvim'
Plug 'smoka7/multicursors.nvim'

call plug#end()

lua << END
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('nvim-web-devicons').setup {
    default = true;
    strict = true;
}

local function mc_is_active()
    local ok, hydra = pcall(require, 'hydra.statusline')
    return ok and hydra.is_active()
end

local function mc_get_name()
    local ok, hydra = pcall(require, 'hydra.statusline')
    if ok then
        return hydra.get_name()
    end
    return ''
end

require('lualine').setup {
    options = { theme = 'gruvbox-material' },
    sections = {
        lualine_a = {
            {
                'mode',
                icon = "󰬔"
            },
            {
                mc_get_name,
                cond = mc_is_active
            }
        },
        lualine_b = {
            'branch',
            {
                'diff',
                symbols = {
                    added = '',
                    modified = '󰝤',
                    removed = ''
                }
            },
            'diagnostics'
        },
        lualine_c = {
            {
                'filename',
                padding = { left = 1, right = 2 },
                separator = { right = '' },
                icon = "󰈔"
            },
            {
                'filesize',
                icon = "󰆼"
            }
        },
        lualine_y = {
            {
                'location',
                separator = { left = '', right = '' },
                padding = { left = 1, right = 2 },
                fmt = function (value) return "[" .. value .. "]" end,
                icon = ""
            },
            {
                'progress',
                icon = "󰡍"
            }
        },
        lualine_z = {
            {
                'hostname',
                separator = { left = '', right = '' },
                padding = { left = 1, right = 2 },
                icon = ""
            },
            {
                'datetime',
                fmt = function (value) return value:gsub("|", " 󰥔") end,
                icon = "󰃶"
            }
        }
    }
}

function nvim_tree_attach(bufnr)
    local api = require 'nvim-tree.api'

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.del('n', '<C-t>', { buffer = bufnr })
    vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
end

require('nvim-tree').setup({
    on_attach = nvim_tree_attach,
    view = {
        width = 40
    }
})

local actions = require 'telescope.actions'

require('telescope').setup{
    defaults = {
        mappings = {
            i = {
                ["<CR>"] = actions.select_tab,
                ["<C-t>"] = actions.select_default,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-j>"] = actions.move_selection_next
            }
        }
    }
}

require('nvim_comment').setup({
    comment_empty = false,
})

require('nvim-surround').setup()

require('multicursors').setup({
    hint_config = false,
    normal_keys = {
        ['<C-c>'] = {
            method = function () vim.api.nvim_input('<ESC>') end,
            opts = { desc = "exit multicursors" }
        }
    }
})
END

nnoremap <C-f> :NvimTreeFocus<CR>
nnoremap <C-t> :NvimTreeToggle<CR>

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>

nnoremap <leader>m :MCunderCursor<cr>

nnoremap U <C-R>
nnoremap <C-w>t :tabnew +term<cr>

inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>l <C-\><C-n><C-w>l
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-c> <C-\><C-n>

inoremap jj <ESC>

:colorscheme gruvbox
