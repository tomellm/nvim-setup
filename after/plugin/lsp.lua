local WIDE_HEIGHT = 40

local cmp = require('cmp')
local compare = cmp.config.compare

local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local get_ws = function(max, len)
    return (" "):rep(max - len)
end

local format = function(_, item)
    if item.menu == nil then
        return item
    end

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

--- Sets the background color of different buffer Types
--- so that they blend in with the other code
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#161616" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#161616" })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#161616" })
    end
})

vim.lsp.enable({
    'ts_ls',
    'eslint',
    'lua_ls',
    'pyright'
})

cmp.setup({
    sources = {
        { name = "jupynium", priority = 1000 }, -- consider higher priority than LSP
        { name = "nvim_lsp", priority = 100 },
        { name = 'luasnip' },
        { name = "crates" },
        -- ...
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = {
            border = "rounded",
            --winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
            --winblend = vim.o.pumblend,
            winhighlight = "Normal:CmpNormal",
            scrolloff = 2,
            col_offset = 0,
            side_padding = 0,
            scrollbar = true,
        },
        documentation = {
            border = "rounded",
            max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
            max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
            winhighlight = 'Normal:CmpNormal',
            winblend = vim.o.pumblend,
            col_offset = 0,
            scrollbar = true,
        },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-f>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<C-b>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
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
    ---@class cmp.FormattingConfig
    formatting = {
        format = format
    }
})

--- The hover action that can be performed in normal mode over any item
--- to show more information about that item. With this function it can
--- be specialized for any different lsp depending on the filetype
local hover_actions_action = function()
    if vim.bo.filetype == 'rust'
    then
        vim.cmd.RustLsp { 'hover', 'actions' }
    else
        vim.lsp.buf.hover({
            border = "rounded"
        })
    end
end

local code_actions_action = function()
    if vim.bo.filetype == "rust" then
        vim.cmd.RustLsp('codeAction')
    else
        vim.lsp.buf.code_action()
    end
end

local code_format_action = function()
    if vim.bo.filetype == "java" then
        require("jdtls").organize_imports()
    end
    vim.lsp.buf.format()
end

local all_diagnostics_action = function()
    require('telescope.builtin').diagnostics({
        sort_by = "severity",
        -- entry_filter = function(entry)
        --     -- entry.filename is an absolute path
        --     return not string.match(entry.filename, "/Users/tomellm/.*")
        -- end,
    })
end

--- List of different configurations of keybinds to their actions
--- allowing them to be added to both the actual vim.keymap set aswell
--- as the which_key index
local lsp_actions = {
    { mode = 'n', cmd = 'K',           action = hover_actions_action,                          desc = 'LSP hover' },
    { mode = 'n', cmd = '<leader>a',   action = code_actions_action,                           desc = 'definitions' },
    { mode = 'n', cmd = '<leader>f',   action = code_format_action,                            desc = 'format' },
    { mode = 'n', cmd = '<leader>ee',  action = function() vim.diagnostic.open_float() end,    desc = 'open diagnostic float' },
    { mode = 'n', cmd = '<leader>ea',  action = all_diagnostics_action,                        desc = 'open all diagnostics' },
    { mode = 'n', cmd = '<leader>vws', action = function() vim.lsp.buf.workspace_symbol() end, desc = 'query workspace symbols' },
    --{ mode = 'n', cmd = '<leader>vd',   action = function() vim.lsp.buf.open_float() end,       desc = 'sdfa' },
    { mode = 'n', cmd = "üb",          action = function() vim.lsp.buf.goto_next() end,        desc = 'next buffer' },
    { mode = 'n', cmd = "+b",          action = function() vim.lsp.buf.goto_prev() end,        desc = 'previous buffer' },
    { mode = "i", cmd = "<C-k>",       action = function() vim.lsp.buf.signature_help() end,   desc = 'LSP signature help' },
    { mode = 'n', cmd = '<leader>gd',  action = '<cmd>Telescope lsp_definitions<CR>',          desc = 'definitions' },
    { mode = 'n', cmd = '<leader>gD',  action = function() vim.lsp.buf.type_definition() end,  desc = 'type definition' },
    { mode = 'n', cmd = '<leader>gL',  action = function() vim.lsp.buf.declaration() end,      desc = 'declaration' },
    { mode = 'n', cmd = '<leader>gi',  action = '<cmd>Telescope lsp_implementations<CR>',      desc = 'implementations' },
    { mode = 'n', cmd = '<leader>gr',  action = '<cmd>Telescope lsp_references<CR>',           desc = 'references float' },
    { mode = "n", cmd = "<leader>grp", action = function() vim.lsp.buf.references() end,       desc = 'references page' },
    { mode = "n", cmd = "<leader>grt", action = "<cmd>ReferencerToggle<CR>",                   desc = 'inline references toggle' },
    { mode = 'n', cmd = '<leader>ca',  action = '<cmd>CodeActionMenu<CR>',                     desc = 'code actions' },
    { mode = 'n', cmd = '<leader>cr',  action = function() vim.lsp.buf.rename() end,           desc = 'rename variable' },
}

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local bufnr = event.buf
        local opts = { buffer = bufnr, remap = false }

        for _, mapping in ipairs(lsp_actions) do
            vim.keymap.set(mapping.mode, mapping.cmd, mapping.action, opts)
        end
    end
})

local M = {}

local lsp_format = require('lsp-format')
local wk = require('which-key')
local illuminate = require('illuminate')

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

vim.lsp.config('*', {
    capabilities = M.capabilities,
})

local function set_keymaps()
    local which_key_mappings = {}
    for key, mapping in ipairs(lsp_actions) do
        which_key_mappings[key] = { mapping.cmd, mapping.action, desc = mapping.desc, mode = mapping.mode }
    end

    wk.add(which_key_mappings)
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
    -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    set_keymaps()
    illuminate.on_attach(client)

    vim.b.lsp_buffer_set_up = 1
end

vim.lsp.config("pyright", {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
})
