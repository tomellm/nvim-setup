local lsp = require("lsp-zero")

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require('luasnip')

lsp.preset("recommended")

lsp.setup_servers({
    'ts_ls',
    'eslint',
    'lua_ls',
    'pyright'
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_select = { behavior = cmp.SelectBehavior.Select }
--------- Stuff for Jupyter Notebook plugin
--------- https://github.com/kiyoon/jupynium.nvim

local compare = cmp.config.compare


local get_ws = function(max, len)
    return (" "):rep(max - len)
end

local format = function(_, item)
    local ELLIPSIS_CHAR = '…'
    local MAX_LABEL_WIDTH = 30
    local menu = item.menu
    if #menu > MAX_LABEL_WIDTH then
        item.menu = vim.fn.strcharpart(menu, 0, MAX_LABEL_WIDTH) .. ELLIPSIS_CHAR
    else
        item.menu = menu .. get_ws(MAX_LABEL_WIDTH, #menu)
    end

    return item
end

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
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                -- that way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
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
    formatting = {
        format = format
    }
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
local M = {}

local lsp_format = require('lsp-format')
local wk = require('which-key')
local illuminate = require('illuminate')

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local function set_commands()
    -- Commands.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.cmd('command! LspDeclaration lua vim.lsp.buf.declaration()')
    vim.cmd('command! LspDef lua vim.lsp.buf.definition()')
    vim.cmd('command! LspFormatting lua vim.lsp.buf.formatting()')
    vim.cmd('command! LspCodeAction lua vim.lsp.buf.code_action()')
    vim.cmd('command! LspHover lua vim.lsp.buf.hover()')
    vim.cmd('command! LspRename lua vim.lsp.buf.rename()')
    vim.cmd('command! LspOrganize lua lsp_organize_imports()')
    vim.cmd('command! LspRefs lua vim.lsp.buf.references()')
    vim.cmd('command! LspTypeDef lua vim.lsp.buf.type_definition()')
    vim.cmd('command! LspImplementation lua vim.lsp.buf.implementation()')
    vim.cmd('command! LspSignatureHelp lua vim.lsp.buf.signature_help()')
    vim.cmd('command! LspWorkspaceList lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))')
    vim.cmd('command! LspWorkspaceAdd lua vim.lsp.buf.add_workspace_folder()')
    vim.cmd('command! LspWorkspaceRemove lua vim.lsp.buf.remove_workspace_folder()')
end

local function set_keymaps(bufnr)
    wk.register({
        g = {
            name = 'LSP goto',
            d = { '<cmd>Telescope lsp_definitions<CR>', 'definitions' },
            D = { '<cmd>LspTypeDef<CR>', 'type definition' },
            L = { '<cmd>LspDeclaration<CR>', 'declaration' },
            i = { '<cmd>Telescope lsp_implementations<CR>', 'implementations' },
            r = { '<cmd>Telescope lsp_references<CR>', 'references' },
        },
        c = {
            name = 'LSP code changes',
            a = { '<cmd>CodeActionMenu<CR>', 'code actions' },
            f = { '<cmd>Format<CR>', 'format' },
            r = { '<cmd>LspRename<CR>', 'rename variable' },
        },
    }, {
        prefix = '<leader>',
        buffer = bufnr,
    })
    wk.register({
        K = { '<cmd>LspHover<CR>', 'LSP hover' },
        ['<C-S>'] = { '<cmd>LspSignatureHelp<CR>', 'LSP signature help' },
    }, {
        buffer = bufnr,
    })
    wk.register({
        ['<C-S>'] = { '<cmd>LspSignatureHelp<CR>', 'LSP signature help' },
    }, {
        mode = 'i',
        buffer = bufnr,
    })
end

function M.on_attach(client, bufnr)
    lsp_format.on_attach(client)
    M.on_attach_no_format(client, bufnr)
end

function M.on_attach_no_format(client, bufnr)
    if vim.b.lsp_buffer_set_up then
        return
    end

    --Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    set_commands()
    set_keymaps(bufnr)
    illuminate.on_attach(client)

    vim.b.lsp_buffer_set_up = 1
end

nvim_lsp.pyright.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
})

lsp.setup()
