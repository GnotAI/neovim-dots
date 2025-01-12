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
    {'jonarrien/telescope-cmdline.nvim'},
    { "gen740/SmoothCursor.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
    { "norcalli/nvim-colorizer.lua" },
    { 'talha-akram/noctis.nvim' },
    { "HiPhish/nvim-ts-rainbow2" },
    { 
      "windwp/nvim-ts-autotag",
      config = true,
    },
    {
      "neanias/everforest-nvim",
      version = "*",
      lazy = false,
      priority = 1000,
    },
    {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      config = true,
    },
    {    
      'numToStr/Comment.nvim',
      lazy = true, 
      keys = {'<leader>space'},
      config = function()
        require('Comment').setup()
      end,
    },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      ---@type snacks.Config
      opts = {
        bigfile = { enabled = true },
        dashboard = { 
          enabled = true,
          width = 60,
          row = nil, -- dashboard position. nil for center
          col = nil, -- dashboard position. nil for center
          pane_gap = 4, -- empty columns between vertical panes
          autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
          -- These settings are used by some built-in sections
          preset = {
            -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
            ---@type fun(cmd:string, opts:table)|nil
            pick = nil,
            -- Used by the `keys` section to show keymaps.
            -- Set your custom keymaps here.
            -- When using a function, the `items` argument are the default keymaps.
            ---@type snacks.dashboard.Item[]
            keys = {
              { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = " ", key = "g", desc = "Change directory", action = function() 
                local dir = vim.fn.input("Enter directory: ", "", "dir")
                if dir ~= "" then
                  vim.cmd("cd " .. dir)
                  print("Switched to directory: " .. dir)
                else
                  print("No directory entered.")
                end
              end },
              { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
              { icon = " ", key = "c", desc = "Config", action = ":cd ~/.config/nvim"},
              { icon = " ", key = "s", desc = "Restore Session", section = "session" },
              { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
            -- Used by the `header` section
            header = [[

  ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          
  ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
  ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
  ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
  ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
  ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           ]],
          },
          -- item field formatters
          formats = {
            icon = function(item)
              if item.file and item.icon == "file" or item.icon == "directory" then
                return M.icon(item.file, item.icon)
              end
              return { item.icon, width = 2, hl = "icon" }
            end,
            footer = { "%s", align = "center" },
            header = { "%s", align = "center" },
            file = function(item, ctx)
              local fname = vim.fn.fnamemodify(item.file, ":~")
              fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
              if #fname > ctx.width then
                local dir = vim.fn.fnamemodify(fname, ":h")
                local file = vim.fn.fnamemodify(fname, ":t")
                if dir and file then
                  file = file:sub(-(ctx.width - #dir - 2))
                  fname = dir .. "/…" .. file
                end
              end
              local dir, file = fname:match("^(.*)/(.+)$")
              return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
            end,
          },
          sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            {
              pane = 2,
              icon = " ",
              desc = "Browse Repo",
              padding = 1,
              key = "b",
              action = function()
                Snacks.gitbrowse()
              end,
            },
            function()
              local in_git = Snacks.git.get_root() ~= nil
              local cmds = {
                {
                  title = "Notifications",
                  cmd = "gh status",
                  action = function()
                    vim.ui.open("https://github.com/notifications")
                  end,
                  key = "n",
                  icon = " ",
                  height = 6,
                  enabled = true,
                },
                {
                  title = "Open Issues",
                  cmd = "gh issue list -L 3",
                  key = "i",
                  action = function()
                    vim.fn.jobstart("gh issue list --web", { detach = true })
                  end,
                  icon = " ",
                  height = 8,
                },
                {
                  icon = " ",
                  title = "Open PRs",
                  cmd = "gh pr list -L 3",
                  key = "p",
                  action = function()
                    vim.fn.jobstart("gh pr list --web", { detach = true })
                  end,
                  height = 8,
                },
                {
                  icon = " ",
                  title = "Git Status",
                  cmd = "git --no-pager diff --stat -B -M -C",
                  height = 11,
                },
              }
              return vim.tbl_map(function(cmd)
                return vim.tbl_extend("force", {
                  pane = 2,
                  section = "terminal",
                  enabled = in_git,
                  padding = 1,
                  ttl = 5 * 60,
                  indent = 3,
                }, cmd)
              end, cmds)
            end,
            { section = "startup" },
          },
        },
        terminal = {
          win = { position = "float" },
        },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = {
          enabled = true,
          timeout = 3000,
        },
        quickfile = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        styles = {
          notification = {
            -- wo = { wrap = true } -- Wrap notifications
          }
        }
      },
      keys = {
        { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
        { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
        { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
        { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
        { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
        { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
        { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
        { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
        { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
        { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
        { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
        { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
        { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
        { "<A-i>",      function() Snacks.terminal.toggle() end, desc = "Toggle Terminal", mode = { "t", "n" } },
        { "<c-.>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
        { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
        { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
        {
          "<leader>N",
          desc = "Neovim News",
          function()
            Snacks.win({
              file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
              width = 0.6,
              height = 0.6,
              wo = {
                spell = false,
                wrap = false,
                signcolumn = "yes",
                statuscolumn = " ",
                conceallevel = 3,
              },
            })
          end,
        }
      },
      init = function()
        vim.api.nvim_create_autocmd("User", {
          pattern = "VeryLazy",
          callback = function()
            -- Setup some globals for debugging (lazy-loaded)
            _G.dd = function(...)
              Snacks.debug.inspect(...)
            end
            _G.bt = function()
              Snacks.debug.backtrace()
            end
            vim.print = _G.dd -- Override print to use snacks for `:=` command

            -- Create some toggle mappings
            Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
            Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
            Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
            Snacks.toggle.diagnostics():map("<leader>ud")
            Snacks.toggle.line_number():map("<leader>ul")
            Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
            Snacks.toggle.treesitter():map("<leader>uT")
            Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
            Snacks.toggle.inlay_hints():map("<leader>uh")
            Snacks.toggle.indent():map("<leader>ug")
            Snacks.toggle.dim():map("<leader>uD")
          end,
        })
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
      --  Use Harpoon defaults or my customizations.

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

      --  Configure Harpoon.

      config = function(_, opts)
        require("harpoon").setup(opts)
      end
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
  },   
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "everforest" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})
