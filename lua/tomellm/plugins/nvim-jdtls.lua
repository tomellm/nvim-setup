return {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
        "neovim/nvim-lspconfig",
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
    },
    config = function()
        local jdtls = require("jdtls")
        local home = vim.fn.expand("~")
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        local workspace_dir = home .. "/.local/share/eclipse/workspace_" .. project_name

        -- JDTLS paths from Nix store (read-only)
        -- /opt/homebrew/Cellar/jdtls/*/libexec/plugins/org.eclipse.equinox.*.jar
        local jdtls_base = vim.fn.glob("/opt/homebrew/opt/jdtls")
        local launcher_path = vim.fn.glob(jdtls_base .. "/libexec/plugins/org.eclipse.equinox.launcher_*.jar")

        -- Writable config directory in home
        local writable_config_dir = jdtls_base .. "/libexec/config_mac/"

        -- Get DAP bundles for debugging (optional but recommended)
        local bundles = {}
        local java_debug_path = vim.fn.glob(
            home
            .. "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
        )
        if java_debug_path ~= "" then
            table.insert(bundles, java_debug_path)
        end

        -- Debug: Check if paths exist
        if launcher_path == "" or jdtls_base == "" then
            vim.notify("JDTLS not found. Check your installation.", vim.log.levels.ERROR)
            return
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- local ok, blink_caps = pcall(require, "blink.cmp")
        -- if ok then
        -- 	capabilities = vim.tbl_deep_extend("force", capabilities, blink_caps.get_lsp_capabilities())
        -- end

        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr }

            -- Enable code lens
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                buffer = bufnr,
                callback = function()
                    vim.lsp.codelens.refresh()
                end,
            })

            vim.keymap.set(
                "n",
                "<leader>oi",
                require("jdtls").organize_imports,
                vim.tbl_extend("force", opts, { desc = "Organize imports" })
            )
            vim.keymap.set(
                "v",
                "<leader>ev",
                require("jdtls").extract_variable,
                vim.tbl_extend("force", opts, { desc = "Extract variable" })
            )
            vim.keymap.set(
                "v",
                "<leader>em",
                require("jdtls").extract_method,
                vim.tbl_extend("force", opts, { desc = "Extract method" })
            )
            vim.keymap.set(
                "n",
                "<leader>tc",
                require("jdtls").test_class,
                vim.tbl_extend("force", opts, { desc = "Test class" })
            )
            vim.keymap.set(
                "n",
                "<leader>tm",
                require("jdtls").test_nearest_method,
                vim.tbl_extend("force", opts, { desc = "Test method" })
            )
        end

        -- Extended DAP configuration
        local extendedClientCapabilities = jdtls.extendedClientCapabilities
        extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

        local config = {
            cmd = {
                "java",
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xms1g",
                "-Xmx2G",
                "--add-modules=ALL-SYSTEM",
                "--add-opens",
                "java.base/java.util=ALL-UNNAMED",
                "--add-opens",
                "java.base/java.lang=ALL-UNNAMED",
                "-jar",
                launcher_path,
                "-configuration",
                writable_config_dir,
                "-data",
                workspace_dir,
            },
            root_dir = require("jdtls.setup").find_root({
                ".git",
                "mvnw",
                "gradlew",
                "pom.xml",
                "build.gradle.kts",
                "build.gradle",
            }),
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                java = {
                    eclipse = {
                        downloadSources = true,
                    },
                    configuration = {
                        updateBuildConfiguration = "interactive",
                    },
                    maven = {
                        downloadSources = true,
                    },
                    implementationsCodeLens = {
                        enabled = true,
                    },
                    referencesCodeLens = {
                        enabled = true,
                    },
                    references = {
                        includeDecompiledSources = true,
                    },
                    format = {
                        enabled = true,
                    },
                    signatureHelp = { enabled = true },
                    contentProvider = { preferred = "fernflower" },
                    completion = {
                        favoriteStaticMembers = {
                            "org.hamcrest.MatcherAssert.assertThat",
                            "org.hamcrest.Matchers.*",
                            "org.hamcrest.CoreMatchers.*",
                            "org.junit.jupiter.api.Assertions.*",
                            "java.util.Objects.requireNonNull",
                            "java.util.Objects.requireNonNullElse",
                            "org.mockito.Mockito.*",
                        },
                        importOrder = {
                            "java",
                            "javax",
                            "org",
                            "com",
                        },
                    },
                    sources = {
                        organizeImports = {
                            starThreshold = 9999,
                            staticStarThreshold = 9999,
                        },
                    },
                    codeGeneration = {
                        toString = {
                            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                        },
                        useBlocks = true,
                    },
                },
            },
            flags = {
                allow_incremental_sync = true,
            },
            init_options = {
                bundles = bundles,
                extendedClientCapabilities = extendedClientCapabilities,
                settings = {
                    java = {
                        implementationsCodeLens = { enabled = true },
                    }
                }
            },
        }

        jdtls.start_or_attach(config)
    end,
}
