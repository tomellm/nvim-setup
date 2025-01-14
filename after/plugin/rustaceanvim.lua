vim.g.rustaceanvim = {
    tools = {
        -- ...
    },
    server = {
        on_attach = function(client, bufnr)
            -- Set keybindings, etc. here.
        end,
        default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
                diagnostics = {
                    disabled = { "inactive-code" }
                },
                procMacro = {
                    ignored = {
                        leptos_macro = {
                            "component",
                            "server",
                        },
                    },
                }
            },
        },
        -- ...
    },
    dap = {
        autoload_configurations = true
    }, --
}
