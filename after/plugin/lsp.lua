local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.setup_servers({
    'tsserver',
    'eslint',
    'lua_ls',
    'rust_analyzer',
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_select = { behavior = cmp.SelectBehavior.Select }
--------- Stuff for Jupyter Notebook plugin
--------- https://github.com/kiyoon/jupynium.nvim

local compare = cmp.config.compare

cmp.setup({
    sources = {
        { name = "jupynium", priority = 1000 }, -- consider higher priority than LSP
        { name = "nvim_lsp", priority = 100 },
        { name = 'luasnip' },
        -- ...
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward()
    }),
    sorting = {
        priority_weight = 1.0,
        comparators = {
            compare.score, -- Jupyter kernel completion shows prior to LSP
            compare.recently_used,
            compare.locality,
            -- ...
        },
    },
})

---------

lsp.set_preferences({
    sign_icons = {}
})

--[[lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})]]

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })

    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.lsp.buf.open_float() end, opts)
    vim.keymap.set("n", "üb", function() vim.lsp.buf.goto_next() end, opts)
    vim.keymap.set("n", "+b", function() vim.lsp.buf.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)


local nvim_lsp = require('lspconfig')

nvim_lsp.rust_analyzer.setup {
    settings = {
        ["rust-analyzer"] = {
             diagnostics = {
                 disabled = {"inactive-code"}
            }
        },
    }
}

lsp.setup()
