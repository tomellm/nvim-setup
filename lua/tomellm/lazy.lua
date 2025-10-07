local PLUGINS = {
    { 'nvim-telescope/telescope.nvim',   tag = '0.1.4',      dependencies = { { 'nvim-lua/plenary.nvim' } } },
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    'nvim-treesitter/playground',

    'mfussenegger/nvim-dap',
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        }
    },

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
        dependencies = { 'hrsh7th/cmp-nvim-lsp' }
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
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/vim-vsnip',


    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    -- SNIPPETS
    { "L3MON4D3/LuaSnip",             version = "v2.*", build = "make install_jsregexp" },
    'rafamadriz/friendly-snippets',

    -- FORMATTING
    { 'lukas-reineke/lsp-format.nvim' },
    --[[{
            'stevearc/conform.nvim',
            opts = require('configs.conform') -- what is this
        },]]

    -- BOTTOM LINE with LSP STATUS
    'nvim-lua/lsp-status.nvim',
    { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons', opt = true } },


    -- LANG SPECIFIC

    -- > RUST
    {
        'mrcjkb/rustaceanvim',
        version = '^5',
        lazy = false,
        ft = { 'rust' }
    },
    {
        'rust-lang/rust.vim',
        ft = 'rust',
        init = function()
            vim.g.rustfmt_autosave = 1
        end
    },
    -- > JAVA
    { "mfussenegger/nvim-jdtls" },
    {
        "oclay1st/gradle.nvim",
        cmd = { "Gradle", "GradleExec", "GradleInit" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        opts = {}, -- options, see default configuration
        keys = { { "<Leader>G", "<cmd>Gradle<cr>", desc = "Gradle" } },
    },

    -- OTHER
    { 'RRethy/vim-illuminate' },                    -- highlights the same variable in different spots
    { 'folke/which-key.nvim' },                     -- information on what keybindings exist
    { 'echasnovski/mini.nvim', version = '*' },     -- icons for which key

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
    { "kiyoon/jupynium.nvim", build = "pip3 install --user ." },

    -- MARKDOWN PREVIEW
    {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
}

require('lazy').setup(PLUGINS)
