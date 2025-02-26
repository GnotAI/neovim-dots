local map = vim.keymap.set

-- General mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<A-h>", "_")
map("n", "<A-l>", "$")
map("i", "jj", "<ESC>")
vim.api.nvim_set_keymap('n', '<leader>Q', ':qa!<CR>', { noremap = true, desc = "Cmdline" })
vim.api.nvim_set_keymap('n', '<leader>ws', ':wa!<CR>', { noremap = true, desc = "Cmdline" })
vim.api.nvim_set_keymap("n", "<leader>a", "ggVG", { noremap = true, silent = true, desc = "Select all" })

map("n", "<leader>pv", vim.cmd.Ex)
vim.api.nvim_set_keymap('n', '<Esc>', ':let @/ = ""<CR>:nohlsearch<CR>', { noremap = true, silent = true })

-- Telescope cmdline mappings
vim.api.nvim_set_keymap('n', ':', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })
vim.api.nvim_set_keymap('n', ';', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })

-- Floaterm mappings
-- vim.api.nvim_set_keymap('n', '<A-i>', ':FloatermToggle<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '<A-i>', '<Esc>:FloatermToggle<CR>', { noremap = true, silent = true }) -- Insert mode
-- vim.api.nvim_set_keymap('t', '<A-i>', '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true, silent = true }) -- Terminal mode

-- Pane/Window work
map("n", "<leader>q", "<C-w>c")
map("n", "<leader>v", "<C-w>v")
map('n', '<C-h>', '<C-w>h', {silent = true})
map('n', '<C-j>', '<C-w>j', {silent = true})
map('n', '<C-k>', '<C-w>k', {silent = true})
map('n', '<C-l>', '<C-w>l', {silent = true})

-- Move cursor around vertically and center
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true, desc = "Scroll down and center" })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true, desc = "Scroll up and center" })
vim.api.nvim_set_keymap("n", "<C-f>", "<C-f>zz", { noremap = true, silent = true, desc = "Scroll up and center" })
vim.api.nvim_set_keymap("n", "<C-b>", "<C-b>zz", { noremap = true, silent = true, desc = "Scroll up and center" })

-- Go to next/previous occurence of word and center
vim.api.nvim_set_keymap("n", "n", "nzz", { noremap = true, silent = true, desc = "Next search result and center" })
vim.api.nvim_set_keymap("n", "N", "Nzz", { noremap = true, silent = true, desc = "Previous search result and center" })

-- Move line (s) vertically 
map('n', '<A-j>', ':m .+1<CR>==', { noremap = true, silent = true })
map('n', '<A-k>', ':m .-2<CR>==', { noremap = true, silent = true })
map('v', '<A-j>', ":m '>+1<CR>==", { noremap = true, silent = true })
map('v', '<A-k>', ":m '<-2<CR>==", { noremap = true, silent = true })

-- Telescope mappings
local tlscp = require('telescope.builtin')
map('n', '<leader>ff', tlscp.find_files, { desc = 'Telescope find files' })
map('n', '<leader>fw', tlscp.live_grep, { desc = 'Telescope live grep' })
map('n', '<leader>fb', tlscp.buffers, { desc = 'Telescope buffers' })
map('n', '<leader>fh', tlscp.help_tags, { desc = 'Telescope help tags' })
map('n', '<leader>fr', ":lua Snacks.dashboard.pick('oldfiles')<CR>", { desc = 'Telescope recent files' })
 
-- Comment api mappings
vim.api.nvim_set_keymap('n', '<leader><leader>', ':lua require("Comment.api").toggle.linewise.current()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader><leader>', ':lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', { noremap = true, silent = true })


