-- Plugin to show the reference count next to lsp
-- Elements, not totally nessesary but nice.
return {
    "romus204/referencer.nvim",
    config = function()
        require("referencer").setup()
    end
}
