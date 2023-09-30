local fold = require('fold-cycle')

vim.keymap.set("n", "<tab>", function() return fold.open() end);
vim.keymap.set("n", "<s-tab>", function() return fold.close() end);
vim.keymap.set("n", "<leader>na", function() return fold.open_all() end);
vim.keymap.set("n", "<leader>na", function() return fold.close_all() end);
vim.keymap.set("n", "<leader>nt", function() return fold.toggle_all() end);
