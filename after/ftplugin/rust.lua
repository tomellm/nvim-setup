local bufnr = vim.api.nvim_get_current_buf()

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
