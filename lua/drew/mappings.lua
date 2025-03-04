-- Helper function for keymap options
local function opts(desc, extra)
  local default = { noremap = true, silent = true, desc = desc }
  return extra and vim.tbl_extend("force", default, extra) or default
end

vim.api.nvim_set_keymap('n', '<leader>Q', ':qa!<CR>', { noremap = true, desc = "Cmdline" })
vim.api.nvim_set_keymap('n', '<leader>ws', ':wa!<CR>', { noremap = true, desc = "Cmdline" })
vim.api.nvim_set_keymap("n", "<leader>a", "ggVG", { noremap = true, silent = true, desc = "Select all" })

vim.api.nvim_set_keymap('n', '<Esc>', ':let @/ = ""<CR>:nohlsearch<CR>', { noremap = true, silent = true })

-- Telescope cmdline mappings
vim.api.nvim_set_keymap('n', ':', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })
vim.api.nvim_set_keymap('n', ';', ':Telescope cmdline<CR>', { noremap = true, desc = "Cmdline" })

-- Floaterm mappings
-- vim.api.nvim_set_keymap('n', '<A-i>', ':FloatermToggle<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '<A-i>', '<Esc>:FloatermToggle<CR>', { noremap = true, silent = true }) -- Insert mode
-- vim.api.nvim_set_keymap('t', '<A-i>', '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true, silent = true }) -- Terminal mode

-- Move cursor around vertically and center
vim.api.nvim_set_keymap("n", "<C-f>", "<C-f>zz", { noremap = true, silent = true, desc = "Scroll up and center" })
vim.api.nvim_set_keymap("n", "<C-b>", "<C-b>zz", { noremap = true, silent = true, desc = "Scroll up and center" })

-- Go to next/previous occurence of word and center
vim.api.nvim_set_keymap("n", "n", "nzz", { noremap = true, silent = true, desc = "Next search result and center" })
vim.api.nvim_set_keymap("n", "N", "Nzz", { noremap = true, silent = true, desc = "Previous search result and center" })

-- Comment api mappings
vim.api.nvim_set_keymap('n', '<leader><leader>', ':lua require("Comment.api").toggle.linewise.current()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader><leader>', ':lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', { noremap = true, silent = true })

local N = "n"
local V = "v"
local I = "i"
local T = "t"
local N_V = { N, V }
local N_I = { N, I }

-- Telescope mappings
local tlscp = require('telescope.builtin')

local keymaps = {
  -- General mappings
  { N, ";", ":", opts("CMD enter command mode" )},
  { N, "<A-h>", "_", opts("Go to beginning of line in normal mode")}
  { N , "<A-l>", "$", opts("Go to end of line in normal mode")}
  { N, "<leader>pv", vim.cmd.Ex, opts("Open file whatever it's called")}
  { N, "<C-d>", "<C-d>zz", opts("Scroll down and center") },
  { N, "<C-u>", "<C-u>zz", opts("Scroll up and center") },

  { N_I, "qq", "<cmd>q<CR>", opts("Quick quit") },

  { I, "jj", "<ESC>", opts("Exits insert mode")}
  { I, "::", "<Esc>:", opts("Enter command mode in insert mode") },

  { V, "d", '"ad', opts("Delete without yanking") },

  -- Pane/Window work
  { N, "<leader>q", "<C-w>c", opts("Close active pane")}
  { N, "<leader>v", "<C-w>v", opts("Open new pane vertically split")}
  { N, '<C-h>', '<C-w>h', opts("Move to left pane")}
  { N, '<C-j>', '<C-w>j', opts("Move to down pane")}
  { N, '<C-k>', '<C-w>k', opts("Move to up pane")}
  { N, '<C-l>', '<C-w>l', opts("Move to right pane")}

  -- Move line(s) vertically
  { N, '<A-j>', ':m .+1<CR>==', opts("Move one line down")}
  { N, '<A-k>', ':m .-2<CR>==', opts("Move one line up")}
  { V, '<A-j>', ":m '>+1<CR>==", opts("Move one line down")}
  { V, '<A-k>', ":m '<-2<CR>==", opts("Move one line up")}

  -- Telescope mappings
  { N, '<leader>ff', tlscp.find_files, opts("Choose from files")}
  { N, '<leader>fw', tlscp.live_grep, opts("Grep for words")}
  { N, '<leader>fb', tlscp.buffers, opts("Choose from active buffers")}
  { N, '<leader>fh', tlscp.help_tags, opts("Help tags")}
  { N, '<leader>fr', ":lua Snacks.dashboard.pick('oldfiles')<CR>", opts("Choose from recent files")}

  -- Extras
  { N, "<C-A-k>", "yy[P", opts("Duplicate line up") },
  { N, "<C-A-j>", "yy]p", opts("Duplicate line down") },
  { V, "<C-A-k>", "yP", opts("Duplicate selection up") },
  { V, "<C-A-j>", "y]p", opts("Duplicate selection down") },

  { N, "<A-q>", "<C-v>", opts("Block selection") },

}

for _, keymap in ipairs(keymaps) do
  local mode = keymap[1]
  local lhs = keymap[2]
  local rhs = keymap[3]
  local options = keymap[4]
  vim.keymap.set(mode, lhs, rhs, options)
end
