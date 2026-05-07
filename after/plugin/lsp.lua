local WIDE_HEIGHT = 40

local cmp = require("cmp")
local compare = cmp.config.compare

local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local get_ws = function(max, len)
	return (" "):rep(max - len)
end

local format = function(_, item)
	if item.menu == nil then
		return item
	end

	local ELLIPSIS_CHAR = "…"
	local MAX_LABEL_WIDTH = 30
	local menu = item.menu
	if #menu > MAX_LABEL_WIDTH then
		item.menu = vim.fn.strcharpart(menu, 0, MAX_LABEL_WIDTH) .. ELLIPSIS_CHAR
	else
		item.menu = menu .. get_ws(MAX_LABEL_WIDTH, #menu)
	end

	return item
end

--- Sets the background color of different buffer Types
--- so that they blend in with the other code
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#161616" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#161616" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#161616" })
	end,
})

vim.lsp.enable({
	"ts_ls",
	"eslint",
	"lua_ls",
	"pyright",
})

cmp.setup({
	sources = {
		{ name = "jupynium", priority = 1000 }, -- consider higher priority than LSP
		{ name = "nvim_lsp", priority = 100 },
		{ name = "luasnip" },
		{ name = "crates" },
		-- ...
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = {
			border = "rounded",
			--winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
			--winblend = vim.o.pumblend,
			winhighlight = "Normal:CmpNormal",
			scrolloff = 2,
			col_offset = 0,
			side_padding = 0,
			scrollbar = true,
		},
		documentation = {
			border = "rounded",
			max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
			max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
			winhighlight = "Normal:CmpNormal",
			winblend = vim.o.pumblend,
			col_offset = 0,
			scrollbar = true,
		},
	},
	mapping = cmp.mapping.preset.insert({
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-f>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-b>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
				-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
				-- that way you will only jump inside the snippet region
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sorting = {
		priority_weight = 1.0,
		comparators = {
			compare.score, -- Jupyter kernel completion shows prior to LSP
			compare.recently_used,
			compare.locality,
			-- ...
		},
	},
	---@class cmp.FormattingConfig
	formatting = {
		format = format,
	},
})

local border_rounded = {
	border = "rounded",
}

--- The hover action that can be performed in normal mode over any item
--- to show more information about that item. With this function it can
--- be specialized for any different lsp depending on the filetype
local hover_actions_action = function()
	if vim.bo.filetype == "rust" then
		vim.cmd.RustLsp({ "hover", "actions" })
	else
		vim.lsp.buf.hover(border_rounded)
	end
end

local code_actions_action = function()
	if vim.bo.filetype == "rust" then
		vim.cmd.RustLsp("codeAction")
	else
		vim.lsp.buf.code_action(border_rounded)
	end
end

local code_format_action = function()
	if vim.bo.filetype == "java" then
		require("jdtls").organize_imports()
	end
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 500,
	})
end

local disagnostics_action = function()
	vim.diagnostic.open_float(border_rounded)
end
local all_diagnostics_action = function()
	require("telescope.builtin").diagnostics({
		sort_by = "severity",
		-- entry_filter = function(entry)
		--     -- entry.filename is an absolute path
		--     return not string.match(entry.filename, "/Users/tomellm/.*")
		-- end,
	})
end

local any_actions = {
	{
		mode = "n",
		cmd = "<leader>ee",
		action = disagnostics_action,
		desc = "open diagnostic float",
	},
}

--- List of different configurations of keybinds to their actions
--- allowing them to be added to both the actual vim.keymap set aswell
--- as the which_key index
local lsp_actions = {
	{ mode = "n", cmd = "K", action = hover_actions_action, desc = "LSP hover" },
	{ mode = "n", cmd = "<leader>a", action = code_actions_action, desc = "definitions" },
	{ mode = "n", cmd = "<leader>f", action = code_format_action, desc = "format" },
	{
		mode = "n",
		cmd = "<leader>ea",
		action = all_diagnostics_action,
		desc = "open all diagnostics",
	},
	{
		mode = "n",
		cmd = "<leader>vws",
		action = vim.lsp.buf.workspace_symbol,
		desc = "query workspace symbols",
	},
	{
		mode = "i",
		cmd = "<C-k>",
		action = vim.lsp.buf.signature_help,
		desc = "LSP signature help",
	},
	{ mode = "n", cmd = "<leader>gd", action = "<cmd>Telescope lsp_definitions<CR>", desc = "definitions" },
	{ mode = "n", cmd = "<leader>gD", action = vim.lsp.buf.type_definition, desc = "type definition" },
	{ mode = "n", cmd = "<leader>gL", action = vim.lsp.buf.declaration, desc = "declaration" },
	{ mode = "n", cmd = "<leader>gi", action = "<cmd>Telescope lsp_implementations<CR>", desc = "implementations" },
	{ mode = "n", cmd = "<leader>gr", action = "<cmd>Telescope lsp_references<CR>", desc = "references float" },
	{ mode = "n", cmd = "<leader>gp", action = vim.lsp.buf.references, desc = "references page" },
	{
		mode = "n",
		cmd = "<leader>gt",
		action = "<cmd>ReferencerToggle<CR>",
		desc = "inline references toggle",
	},
	{ mode = "n", cmd = "<leader>ca", action = "<cmd>CodeActionMenu<CR>", desc = "code actions" },
	{ mode = "n", cmd = "<leader>cr", action = vim.lsp.buf.rename, desc = "rename variable" },
}
local function register_keybindings(actions, event)
	local bufnr = event.buf
	local opts = { buffer = bufnr, remap = false }

	-- Attach Key Mappings
	for _, mapping in ipairs(actions) do
		if mapping.mode and mapping.cmd and mapping.action then
			vim.keymap.set(mapping.mode, mapping.cmd, mapping.action, opts)
		else
			error(
				"one of the values for this keymapping was nil, mode: '"
					.. tostring(mapping.mode)
					.. "' cmd: '"
					.. tostring(mapping.cmd)
					.. "' action: '"
					.. tostring(mapping.action)
					.. "'"
			)
		end
	end
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function(event)
		register_keybindings(any_actions, event)
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		register_keybindings(lsp_actions, event)
		-- Show Codelens
		-- if client and client:supports_method("textDocument/codeLens") then
		-- 	vim.lsp.codelens.enable(true)
		-- end
	end,
})

-- local M = {}
--
-- local lsp_format = require('lsp-format')
-- local wk = require('which-key')
-- local illuminate = require('illuminate')
--
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- M.capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
--
-- vim.lsp.config('*', {
--     capabilities = M.capabilities,
-- })
--
-- local function set_keymaps()
--     local which_key_mappings = {}
--     for key, mapping in ipairs(lsp_actions) do
--         which_key_mappings[key] = { mapping.cmd, mapping.action, desc = mapping.desc, mode = mapping.mode }
--     end
--
--     wk.add(which_key_mappings)
-- end
--
-- function M.on_attach(client, bufnr)
--     lsp_format.on_attach(client)
--     M.on_attach_no_format(client, bufnr)
-- end
--
-- function M.on_attach_no_format(client, bufnr)
--     if vim.b.lsp_buffer_set_up then
--         return
--     end
--
--     --Enable completion triggered by <c-x><c-o>
--     -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--     set_keymaps()
--     illuminate.on_attach(client)
--
--     vim.b.lsp_buffer_set_up = 1
-- end
--
-- vim.lsp.config("pyright", {
--     on_attach = M.on_attach,
--     capabilities = M.capabilities,
-- })
