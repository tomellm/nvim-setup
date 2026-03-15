vim.keymap.set("n", "<leader>qt", "<cmd>DBUIToggle<CR>")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "dbout",
    callback = function()
        vim.wo.foldenable = false
    end,
})
