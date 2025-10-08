require('lazy').setup({
    spec = {
        { import = "tomellm.plugins" }
    },
})

vim.o.background = "dark" -- or "light" for light mode
vim.cmd.colorscheme("carbonfox")
