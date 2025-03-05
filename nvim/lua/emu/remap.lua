vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "-", vim.cmd.Ex)
vim.keymap.set("n", "<leader>w", vim.cmd.write)
vim.keymap.set("n", "<leader><leader>", ":e #<cr>")

vim.keymap.set("n", "<leader>l", ":set hlsearch!<cr>")
--
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set("n", "<C-h>", ":wincmd h<cr>", {silent = true})
vim.keymap.set("n", "<C-j>", ":wincmd j<cr>", {silent = true})
vim.keymap.set("n", "<C-k>", ":wincmd k<cr>", {silent = true})
vim.keymap.set("n", "<C-l>", ":wincmd l<cr>", {silent = true})

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.cmd("iabbr cl console.log")
vim.cmd("iabbr iunno ¯\\_(ツ)_/¯")
--vim.cmd 'iabbr <expr> dts strftime("%a %Y-%m-%d")'
--vim.cmd 'iabbr <expr> ts strftime("%I:%M %p")'

vim.keymap.set("n", "<leader>/", ":set hlsearch!<cr>")
vim.keymap.set("n", "<leader>n", ":set relativenumber!<cr>")
vim.keymap.set("n", "<leader>W", ":set wrap!<cr>:set wrap?<cr>")
vim.keymap.set("n", "<leader>C", Toggle_enable_cmp)
vim.keymap.set("n", "<leader>t", ":e `todays_file`<cr>")
vim.keymap.set("n", "<leader>f", ":Ag<cr>")

-- vim.keymap.set("n", "<leader>s", vim.cmd.source)

-- vim.keymap.set("n", "<leader>q", ":!chatblade -e ")
-- vim.keymap.set("n", "<leader>Q", ":r!chatblade -e ")
-- vim.keymap.set("v", "<leader>Q", ":r!chatblade -e ")

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")



-- remap up and down to work across wrapped lines
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("v", "j", "gj")
vim.keymap.set("v", "k", "gk")
