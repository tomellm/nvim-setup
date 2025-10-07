local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

local keymap = vim.keymap

local opts = { noremap = true, silent = true }
-- from here https://raw.githubusercontent.com/justicenyaga/my_nvim_config/master/ftplugin/java.lua
local lsp_attach = function(client, bufnr)
    require("jdtls.dap").setup_dap_main_class_configs() -- Discover main classes for debugging

    opts.buffer = bufnr

    -- vim.api.nvim_create_autocmd({ 'BufWriteCmd' }, {
    --     pattern = '*.java',
    --     callback = function(_)
    --         require('jdtls').organize_imports()
    --         --vim.lsp.buf.format()
    --     end
    -- })
end

local config = {
    cmd = { 
        jdtls_bin,
        '-data', vim.fn.getcwd() .. '/build'
    },
    root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = false })[1]),
    on_attach = lsp_attach,
    init_options = {
        -- bundles = {
        --   vim.fn.glob(vim.fn.stdpath("data") .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1),
        -- },
    },
}

require("jdtls").start_or_attach(config)
