vim.g.rustaceanvim = function()
    return {
        tools = {
            hover_actions = {
                replace_builtin_hover = true,
            },
            float_win_config = {
                border = "rounded",
            },
        },
        server = {
            on_attach = function(client, bufnr)
                require('lsp-format').on_attach(client)
            end,
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
    };
end
