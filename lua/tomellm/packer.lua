-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use({
        "ellisonleao/gruvbox.nvim",
        as = "gruvbox",
        config = function()
            vim.cmd("colorscheme gruvbox");
        end
    })

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    use('nvim-treesitter/playground')

    use('ThePrimeagen/harpoon')

    use('mbbill/undotree')

    use('tpope/vim-fugitive')

    use('tpope/vim-dadbod')
    use('kristijanhusak/vim-dadbod-ui')
    use('kristijanhusak/vim-dadbod-completion')

    use('christoomey/vim-tmux-navigator')


    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },


            { 'hrsh7th/nvim-cmp' }, -- Required
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'hrsh7th/cmp-nvim-lua' },
            { 'L3MON4D3/LuaSnip' }, -- Required
            { 'rafamadriz/friendly-snippets' },
        }
    }

    -- install without yarn or npm
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })


    use {
        'chikko80/error-lens.nvim',
        requires = { 'nvim-telescope/telescope.nvim' }
    }

    use {'nvim-lua/lsp-status.nvim'}
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }


    -- https://github.com/kiyoon/jupynium.nvim
    use { "kiyoon/jupynium.nvim", run = "pip3 install --user ." }
end)
