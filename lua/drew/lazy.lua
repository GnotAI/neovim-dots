local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { "windwp/nvim-autopairs" },
    { "nvim-lualine/lualine.nvim" }, 
    { "voldikss/vim-floaterm" },
    {'jonarrien/telescope-cmdline.nvim'},
    { "gen740/SmoothCursor.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
    {
        'huy-hng/anyline.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = true,
        event = 'VeryLazy',
    },
    {
      "neanias/everforest-nvim",
      version = "*",
      lazy = false,
      priority = 1000,
    },
    {    
      'numToStr/Comment.nvim',
      lazy = true, 
      keys = {'<leader>/', '<leader>u'},
      config = function()
        require('Comment').setup()
      end,
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",    -- LSP completion
        "L3MON4D3/LuaSnip",        -- Snippet engine
        "saadparwaiz1/cmp_luasnip",-- Snippet source for cmp
        "hrsh7th/cmp-buffer",      -- Buffer completion
        "hrsh7th/cmp-path",        -- Path completion
      },
    },
    {
      "ThePrimeagen/harpoon",
      enabled = true,
      event = {"InsertEnter", "CmdLineEnter"},
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", },
    },
    {
      'nvim-telescope/telescope.nvim', 
      tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
      "vim-test/vim-test",
      dependencies = {
        "preservim/vimux"
      },
    },
    {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
    },
    {
      "nvimdev/dashboard-nvim",
      event = "VimEnter",
    },
    {
      "folke/persistence.nvim",
      event = "BufReadPre", -- Load the plugin on buffer read
      config = function()
        require("persistence").setup({
          dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"), -- Save sessions in this directory
          options = { "buffers", "curdir", "tabpages", "winsize" }, -- What to store in the session
        })
      end,
    },
    {
      "folke/twilight.nvim",
      lazy = true,  -- Plugin will be loaded lazily
      event = "BufReadPost",  -- Load Twilight when a file is opened
      config = function()
        require("twilight").setup {
          -- Optional settings for Twilight
          dimming = {
            alpha = 0.25, -- Amount of dimming
          },
          context = 10, -- How many lines to show around the current line
          expand = { -- Filetypes to ignore when expanding the visible text
            "markdown",
            "help",
          },
        }
        -- Automatically enable Twilight on file open
        vim.cmd("TwilightEnable")
      end,
    },
    {    
      "kdheepak/lazygit.nvim",
      lazy = true,
      cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
      },
      -- optional for floating window border decoration
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      -- setting the keybinding for LazyGit with 'keys' is recommended in
      -- order to load the plugin when the command is run for the first time
      keys = {
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
      }
    },
  },   
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "everforest" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})
