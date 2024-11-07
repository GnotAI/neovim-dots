-- Bootstrap lazy.nvim
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
    {
      "neanias/everforest-nvim",
      version = "*",
      lazy = false,
      priority = 1000,
    },
    { "windwp/nvim-autopairs" },
    { "nvim-lualine/lualine.nvim" }, 
    { "neovim/nvim-lspconfig", },
    {"voldikss/vim-floaterm"},
    {'jonarrien/telescope-cmdline.nvim'},
    {    
      'numToStr/Comment.nvim',
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
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)  -- Use LuaSnip
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),      -- Scroll docs up with Ctrl-b
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()  -- Select next completion item
              else
                cmp.mapping.scroll_docs(4)(fallback)  -- Scroll docs down
              end
            end, { "i", "s" }),  -- Enable in insert and select modes
            ["<C-Space>"] = cmp.mapping.complete(),       -- Trigger completion
            ["<C-e>"] = cmp.mapping.abort(),              -- Abort completion
            ["<CR>"] = cmp.mapping.confirm({ select = true }),  -- Confirm completion
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
          }),
        })

        -- Command-line mode setup
        cmp.setup.cmdline(":", {
          sources = cmp.config.sources({
            { name = "path" },
            { name = "cmdline" },
          }),
        })
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
    },
    {
      -- {{{ Define the Harpoon lazy.vim specificaiton.

      "ThePrimeagen/harpoon",
      enabled = true,
      event = {"InsertEnter", "CmdLineEnter"},
      branch = "harpoon2",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
      },

      -- ----------------------------------------------------------------------- }}}
      -- {{{ Define events to load Harpoon.

      keys = function()
        local harpoon = require("harpoon")
        local conf = require("telescope.config").values

        local function toggle_telescope(harpoon_files)
          local file_paths = {}
          for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
          end
          require("telescope.pickers").new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          }):find()
        end


        return {
          -- Harpoon marked files 1 through 4
          {"<a-1>", function() harpoon:list():select(1) end, desc ="Harpoon buffer 1"},
          {"<a-2>", function() harpoon:list():select(2) end, desc ="Harpoon buffer 2"},
          {"<a-3>", function() harpoon:list():select(3) end, desc ="Harpoon buffer 3"},
          {"<a-4>", function() harpoon:list():select(4) end, desc ="Harpoon buffer 4"},

          -- Harpoon next and previous.
          {"<a-5>", function() harpoon:list():next() end, desc ="Harpoon next buffer"},
          {"<a-6>", function() harpoon:list():prev() end, desc ="Harpoon prev buffer"},

          -- Harpoon user interface.
          {"<a-7>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc ="Harpoon Toggle Menu"},
          {"<a-8>", function() harpoon:list():add() end, desc ="Harpoon add file"},

          -- Use Telescope as Harpoon user interface.
          {"<a-9>", function() toggle_telescope(harpoon:list() )end, desc ="Open Harpoon window"},
        }
      end,

      -- ----------------------------------------------------------------------- }}}
      -- {{{ Use Harpoon defaults or my customizations.

      opts = function(_, opts)
        opts.settings = {
          save_on_toggle = false,
          sync_on_ui_close = false,
          save_on_change = true,
          enter_on_sendcmd = false,
          tmux_autoclose_windows = false,
          excluded_filetypes = { "harpoon", "alpha", "dashboard", "gitcommit" },
          mark_branch = false,
          key = function()
            return vim.loop.cwd()
          end
        }
      end,

      -- ----------------------------------------------------------------------- }}}
      -- {{{ Configure Harpoon.

      config = function(_, opts)
        require("harpoon").setup(opts)
      end,

      -- ----------------------------------------------------------------------- }}}
    },
    {
      'nvim-telescope/telescope.nvim', tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
      "vim-test/vim-test",
      dependencies = {
        "preservim/vimux"
      },
      config = function()
        vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", {})
        vim.keymap.set("n", "<leader>T", ":TestFile<CR>", {})
        vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", {})
        vim.keymap.set("n", "<leader>l", ":TestLast<CR>", {})
        vim.keymap.set("n", "<leader>g", ":TestVisit<CR>", {})
        vim.cmd("let test#strategy = 'vimux'")
      end,
    },
    {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({
          -- Configuration here, or leave empty to use defaults
        })
      end
    },
    {
      "nvimdev/dashboard-nvim",
      event = "VimEnter",
      opts = function()
        local logo = [[
        ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
        ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
        ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
        ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
        ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
        ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
        ]]

        logo = string.rep("\n", 8) .. logo .. "\n\n"

        local opts = {
          theme = "doom",
          hide = {
            -- this is taken care of by lualine
            -- enabling this messes up the actual laststatus setting after loading a file
            statusline = false,
          },
          config = {
            header = vim.split(logo, "\n"),
            -- stylua: ignore
            center = {
              { action = function() 
                local dir = vim.fn.input("Enter directory: ", "", "dir")
                if dir ~= "" then
                  vim.cmd("cd " .. dir)
                  print("Switched to directory: " .. dir)
                else
                  print("No directory entered.")
                end
              end,                                     desc = " Open directory",     icon = " ", key = "o" },
              { action = function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":Telescope find_files<cr>", true, false, true), "n", true) end,                           desc = " Find File",       icon = " ", key = "f" },
              { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
              { action = function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":Telescope oldfiles<cr>", true, false, true), "n", true) end,                 desc = " Recent Files",    icon = " ", key = "r" },
              { action = function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":Telescope live_grep<cr>", true, false, true), "n", true) end,                desc = " Find Text",       icon = " ", key = "g" },
              { action = function() vim.cmd("cd ~/.config/nvim") end,              desc = " Config",          icon = " ", key = "c" },
              { action = function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":lua require('persistence').load()<cr>", true, false, true), "n", true) end,              desc = " Restore Session", icon = " ", key = "s" },
              { action = function() vim.api.nvim_input("<cmd>Lazy<cr>") end,                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
              { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
            },
            footer = function()
              local stats = require("lazy").stats()
              local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
              return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
            end,
          },
        }

        for _, button in ipairs(opts.config.center) do
          button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
          button.key_format = "  %s"
        end

        -- open dashboard after closing lazy
        if vim.o.filetype == "lazy" then
          vim.api.nvim_create_autocmd("WinClosed", {
            pattern = tostring(vim.api.nvim_get_current_win()),
            once = true,
            callback = function()
              vim.schedule(function()
                vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
              end)
            end,
          })
        end

        return opts
      end
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

