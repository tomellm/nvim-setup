-- https://github.com/Saecki/crates.nvim?tab=readme-ov-file
return {
    'saecki/crates.nvim',
    tag = 'stable',
    event = { "BufRead Cargo.toml" },
    config = function()
        require('crates').setup({
            completion = {
                cmp = {
                    enabled = true,
                },
                crates = {
                    enabled = true, -- disabled by default
                    max_results = 8, -- The maximum number of search results to display
                    min_chars = 3 -- The minimum number of charaters to type before completions begin appearing
                },
                null_ls = {
                    enabled = true,
                    name = "crates.nvim",
                },
            },
        })
    end,
}
