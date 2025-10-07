vim.g.rustaceanvim = {
    server = {
        default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
                diagnostics = {
                    disabled = { "inactive-code" }
                },
                ["cargo"] = {
                    ["allFeatures"] = true,
                },
                --[[procMacro = {
                    ignored = {
                        leptos_macro = {
                            "component",
                            "server",
                        },
                    },
                }]]
            },
        },
    },
    dap = {
        autoload_configurations = true
    },
}
