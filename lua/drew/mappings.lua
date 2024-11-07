local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "kj", "<ESC>")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.api.nvim_set_keymap('n', '<Esc>', ':let @/ = ""<CR>:nohlsearch<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })

-- Telescope cmdline mappings
vim.api.nvim_set_keymap('n', ':', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })
vim.api.nvim_set_keymap('n', ';', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })

-- Floaterm mappings
vim.api.nvim_set_keymap('n', '<A-i>', ':FloatermToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-i>', '<Esc>:FloatermToggle<CR>', { noremap = true, silent = true }) -- Insert mode
vim.api.nvim_set_keymap('t', '<A-i>', '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true, silent = true }) -- Terminal mode

-- Move cursor around vertically and center
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true, desc = "Scroll down and center" })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true, desc = "Scroll up and center" })

-- Go to next/previous occurence of word and center
vim.api.nvim_set_keymap("n", "n", "nzz", { noremap = true, silent = true, desc = "Next search result and center" })
vim.api.nvim_set_keymap("n", "N", "Nzz", { noremap = true, silent = true, desc = "Previous search result and center" })

-- Move line (s) vertically 
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>==", { noremap = true, silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>==", { noremap = true, silent = true })

-- Telescope mappings
local tlscp = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', tlscp.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fw', tlscp.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', tlscp.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', tlscp.help_tags, { desc = 'Telescope help tags' })

-- Comment api mappings
vim.api.nvim_set_keymap('n', '<leader>/', ':lua require("Comment.api").toggle.linewise.current()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>u', ':lua require("Comment.api").uncomment.linewise.current()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>/', ':lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>u', ':lua require("Comment.api").uncomment.linewise(vim.fn.visualmode())<CR>', { noremap = true, silent = true })
