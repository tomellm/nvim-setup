vim.keymap.set("n", "qq", "")
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StartVimWithMe()
end)


vim.keymap.set("n", "<leader>p", "\"_dP")
vim.keymap.set("x", "<leader>p", "\"_dP")


vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")


vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")


vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", function()
    if vim.bo.filetype == 'java'
    then
        require('jdtls').organize_imports()
    end
    vim.lsp.buf.format()
end)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>+x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- buffer management
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>")
vim.keymap.set("n", "<leader>bp", "<cmd>bprev<CR>")
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>")
vim.keymap.set("n", "<leader>bl", "<cmd>ls<CR>")
vim.keymap.set("n", "<leader>bw", "<cmd>w<CR>")
vim.keymap.set("n", "<leader>bq", "<cmd>q<CR>")
vim.keymap.set("n", "<leader>bs", "<cmd>w<CR>")

-- window management
vim.keymap.set("n", "<leader>wh", "<cmd>split<CR>")
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<CR>")
vim.keymap.set("n", "<leader>wn", "<cmd>new<CR>")
vim.keymap.set("n", "<leader>wm", "<cmd>vnew<CR>")
vim.keymap.set("n", "<leader>wc", "<cmd>close<CR>")
vim.keymap.set("n", "<leader>wg", "<cmd>hide<CR>")

-- window resizing
vim.keymap.set("n", "<leader><Right>", "<C-W>>5")
vim.keymap.set("n", "<leader><Left>", "<C-W><5")
vim.keymap.set("n", "<leader><Up>", "<C-W>+5")
vim.keymap.set("n", "<leader><Down>", "<C-W>-5")

-- tab management
vim.keymap.set("n", "<leader>tc", "<cmd>tabnew<CR>")
vim.keymap.set("n", "<leader>td", "<cmd>tabclose<CR>")
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>")
vim.keymap.set("n", "<leader>tp", "<cmd>tabnprevious<CR>")

-- error management
vim.keymap.set("n", "<leader>ee", function()
    vim.diagnostic.open_float()
end)

vim.keymap.set("n", "<leader>ea", function()
    require('telescope.builtin').diagnostics({ sort_by = "severity" })
end)

-- DB commandos

vim.keymap.set("n", "<leader>qt", "<cmd>DBUIToggle<CR>")


-- Greek letters

vim.keymap.set("i", "<C-g>g", "<C-k>g*") -- gamma
vim.keymap.set("i", "<C-g>d", "<C-k>d*") -- delta
vim.keymap.set("i", "<C-g>h", "<C-k>h*") -- theta
vim.keymap.set("i", "<C-g>p", "<C-k>p*") -- pi
vim.keymap.set("i", "<C-g>s", "<C-k>s*") -- sigma
vim.keymap.set("i", "<C-g>f", "<C-k>f*") -- phi
vim.keymap.set("i", "<C-g>w", "<C-k>w*") -- omega
vim.keymap.set("i", "<C-g>q", "<C-k>q*") -- psi
vim.keymap.set("i", "<C-g>a", "<C-k>a*") -- alpha
vim.keymap.set("i", "<C-g>b", "<C-k>b*") -- beta
vim.keymap.set("i", "<C-g>e", "<C-k>e*") -- epsilon
vim.keymap.set("i", "<C-g>l", "<C-k>l*") -- lambda
vim.keymap.set("i", "<C-g>t", "<C-k>t*") -- tau


-- Markdown Preview
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>")


-- count words
vim.keymap.set("n", "<leader>cr", "<cmd>!find . -name '*.rs' -type f -exec wc -l {} +<CR>")
