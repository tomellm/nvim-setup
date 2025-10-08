require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls' },
    automatic_installation = true,
    handlers = {
        function (server_name)
            vim.lsp.config(server_name, {})
        end
    }
})


