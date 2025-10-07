local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
    "n",
    "<leader>a",
    function()
        vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
        -- or vim.lsp.buf.codeAction() if you don't want grouping.
    end,
    { silent = true, buffer = bufnr }
)

vim.keymap.set("n", "<leader>er", function()
    vim.cmd.RustLsp({ 'explainError', 'cycle' })
end)
vim.keymap.set("n", "<leader>ern", function()
    vim.cmd.RustLsp({ 'explainError', 'cycle' })
end)
vim.keymap.set("n", "<leader>erp", function()
    vim.cmd.RustLsp({ 'explainError', 'cycle_prev' })
end)

vim.keymap.set("n", "<leader>Kd", function()
    vim.cmd.RustLsp('openDocs')
end)

vim.keymap.set("n", "<leader>pr", function()
    vim.cmd.RustLsp('workspaceSymbol')
end)
