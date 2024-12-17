require('lazy').setup(
    {
        { 'nvim-telescope/telescope.nvim',   tag = '0.1.4',      dependencies = { { 'nvim-lua/plenary.nvim' } } },
        { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
        'nvim-treesitter/playground',

        'mfussenegger/nvim-dap',

        'ThePrimeagen/harpoon',

        'mbbill/undotree',

        'tpope/vim-fugitive',


        -- MASON and LSP
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v3.x',
            lazy = true,
            config = false,
        },
        {
            'neovim/nvim-lspconfig',
            dependencies = {
                'hrsh7th/cmp-nvim-lsp'
            }
        },
        -- AUTOCOMPLETION
        {
            'hrsh7th/nvim-cmp',
            version = false, -- last release is way too old
            event = "InsertEnter",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                'saadparwaiz1/cmp_luasnip'
            },
        },
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'hrsh7th/vim-vsnip',

        -- SNIPPETS
        { "L3MON4D3/LuaSnip",             version = "v2.*", build = "make install_jsregexp" },
        'rafamadriz/friendly-snippets',

        -- FORMATTING
        { 'lukas-reineke/lsp-format.nvim' },


        -- BOTTOM LINE with LSP STATUS
        'nvim-lua/lsp-status.nvim',
        { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons', opt = true } },


        -- LANG SPECIFIC
        {
            'mrcjkb/rustaceanvim',
            version = '^5',
            lazy = false,
            ft = { 'rust' },
        },

        -- OTHER
        { 'RRethy/vim-illuminate' },
        { 'folke/which-key.nvim' },

        -- THEME
        { "EdenEast/nightfox.nvim" },


        -----------------------
        ---- SPECIAL STUFF ----
        -----------------------

        -- DATABASE UI
        'tpope/vim-dadbod',
        'kristijanhusak/vim-dadbod-ui',
        'kristijanhusak/vim-dadbod-completion',

        -- JUPYTER NOTEBOOK
        { "kiyoon/jupynium.nvim",         build = "pip3 install --user ." },

        -- MARKDOWN PREVIEW
        { "iamcco/markdown-preview.nvim", build = function() vim.fn["mkdp#util#install"]() end, },


    }
)
