local dap, dapui = require("dap"), require("dapui")

dap.adapters.lldb = {
	type = "executable",
    name = "lldb",
	command = "/usr/bin/lldb", -- adjust as needed
}


vim.keymap.set('n', '<leader>dn', "<cmd>DapNew<CR>");
vim.keymap.set('n', '<leader>dx', "<cmd>DapTerminate<CR>");

vim.keymap.set('n', '<leader>dc', "<cmd>DapConttinue<CR>");
vim.keymap.set('n', '<leader>dsi', "<cmd>DapStepInto<CR>");
vim.keymap.set('n', '<leader>dso', "<cmd>DapStepOut<CR>");
vim.keymap.set('n', '<leader>dsv', "<cmd>DapStepOver<CR>");

vim.keymap.set('n', '<leader>dbt', "<cmd>DapToggleBreakpoint<CR>");
vim.keymap.set('n', '<leader>dbc', "<cmd>DapClearBreakpoints<CR>");

dapui.setup();

vim.keymap.set('n', '<leader>dui', function() dapui.open() end);
vim.keymap.set('n', '<leader>dux', function() dapui.close() end);
