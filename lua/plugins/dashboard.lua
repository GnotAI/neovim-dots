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
