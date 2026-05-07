return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main", -- optional as main is default, but I like being explicit
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				-- Enable treesitter highlighting and disable regex syntax
				pcall(vim.treesitter.start)
				-- Enable treesitter-based indentation
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		local ensureInstalled = {
			"lua",
			"python",
			"typescript",
			"rust",
			"javascript",
			"java",
			"kotlin",
			"groovy",
			"toml",
			"xml",
			"markdown",
			"yaml",
		}
		local alreadyInstalled = require("nvim-treesitter.config").get_installed()
		local parsersToInstall = vim.iter(ensureInstalled)
			:filter(function(parser)
				return not vim.tbl_contains(alreadyInstalled, parser)
			end)
			:totable()
		if #parsersToInstall > 0 then
			require("nvim-treesitter").install(parsersToInstall)
		end
	end,
}
