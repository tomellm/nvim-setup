require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls' },
    automatic_installation = true,
    handlers = {
        function (server_name)
            require('lspconfig')[server_name].setup({})
        end
    }
})


