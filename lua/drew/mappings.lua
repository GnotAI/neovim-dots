-- Helper function for keymap options
local function opts(desc, extra)
  local default = { noremap = true, silent = true, desc = desc }
  return extra and vim.tbl_extend("force", default, extra) or default
end

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
  { N, '<leader>ws', ':wa!<CR>', opts("Save")},
  { N, "<leader>a", "ggVG", opts("Select all")},
  { N, "<leader>pv", vim.cmd.Ex, opts("Open file whatever it's called")},
  { N, ':', '<cmd>Telescope cmdline<CR>', opts("Opens cmdline")},
  { N, ';', '<cmd>Telescope cmdline<CR>', opts("Opens cmdline")},
  { N, "<C-d>", "zzzz<C-d>zz", opts("Scroll down while centered") },
  { N, "<C-u>", "zzzz<C-u>zz", opts("Scroll up while centered") },
  { N, "n", "zznzz", opts("Previous search result and center" )},
  { N, "N", "zzNzz", opts("Previous search result and center" )},
  { N, '<Esc>', ':let @/ = ""<CR>:nohlsearch<CR>', opts("Cancel buf search with esc")},

  { N_I, "qq", "<cmd>qa!<CR>", opts("Quick quit") },






  { I, "jj", "<ESC>", opts("Exits insert mode")},
  { I, "::", "<Esc>:", opts("Enter command mode in insert mode") },

  { V, "d", '"ad', opts("Delete without yanking") },

  -- Pane/Window work
  { N, "<leader>q", "<C-w>c", opts("Close active pane")},
  { N, "<leader>v", "<C-w>v", opts("Open new pane vertically split")},
  { N, '<C-h>', '<C-w>h', opts("Move to left pane")},
  { N, '<C-j>', '<C-w>j', opts("Move to down pane")},
  { N, '<C-k>', '<C-w>k', opts("Move to up pane")},
  { N, '<C-l>', '<C-w>l', opts("Move to right pane")},

  -- Move cursor around vertically and center
  { N, "<C-f>", "zz<C-f>", opts("Scroll up and center")},
  { N, "<C-b>", "zz<C-b>", opts("Scroll up and center")},

  -- Move line(s) vertically
  { N, '<A-j>', ':m .+1<CR>==', opts("Move one line down")},
  { N, '<A-k>', ':m .-2<CR>==', opts("Move one line up")},
  { V, '<A-j>', ":m '>+1<CR>==", opts("Move one line down")},
  { V, '<A-k>', ":m '<-2<CR>==", opts("Move one line up")},

  -- Comment api mappings
  { N, '<leader><leader>', ':lua require("Comment.api").toggle.linewise.current()<CR>', opts("Comment line")},
  { V, '<leader><leader>', ':lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', opts("Comment line")},

  -- Telescope mappings
  { N, '<leader>ff', tlscp.find_files, opts("Choose from files")},
  { N, '<leader>fw', tlscp.live_grep, opts("Grep for words")},
  { N, '<leader>fb', tlscp.buffers, opts("Choose from active buffers")},
  { N, '<leader>fh', tlscp.help_tags, opts("Help tags")},
  { N, '<leader>fr', ":lua Snacks.dashboard.pick('oldfiles')<CR>", opts("Choose from recent files")},

  -- Extras
  { N, "<C-A-k>", "yy[P", opts("Duplicate line up") },
  { N, "<C-A-j>", "yy]p", opts("Duplicate line down") },
  { V, "<C-A-k>", "yP", opts("Duplicate selection up") },
  { V, "<C-A-j>", "y]p", opts("Duplicate selection down") },
}

for _, keymap in ipairs(keymaps) do
  local mode = keymap[1]
  local lhs = keymap[2]
  local rhs = keymap[3]
  local options = keymap[4]
  vim.keymap.set(mode, lhs, rhs, options)
end
