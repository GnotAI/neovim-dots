return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  extensions = { "quickfix", "trouble", "oil" },

  config = function()
    local function get_tmux_info()
      local handle = io.popen("tmux display-message -p '#S '")
      local session_name = handle and handle:read("*a") or "No Tmux"
      if handle then handle:close() end

      -- Get all windows in the session, marking the active one
      local handle_windows = io.popen("tmux list-windows -F '#I:#W#{?window_active,* , }'")
      local windows = handle_windows and handle_windows:read("*a") or "No Windows"
      if handle_windows then handle_windows:close() end

      -- Format the window list
      windows = windows:gsub("\n", " ") -- Separate windows with " | "

      return " " ..  session_name:gsub('\n', " ") .. windows  
    end

    local function lsp_name()
      local clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
      if #clients == 0 then
        return "No Active LSP"
      end

      -- Concatenate all client names for the buffer
      local client_names = {}
      for _, client in ipairs(clients) do
        table.insert(client_names, client.name)
      end
      return table.concat(client_names, ", ")
    end

    -- Lualine configuration
    require("lualine").setup({
        options = {
          theme = everforest,
          component_separators = '|',
          section_separators = { left = '', right = '' },
          globalstatus = true,
        },
        sections = {
          lualine_a = {
            { 'mode' },
          },
          lualine_b = { 'branch', 'diff' },
          lualine_c = {
            -- {
              --   -- get_project_root,
              --   path,
              --   icon = " ",
              --   separator = "",
            -- },
            "diagnostics",
            { get_tmux_info },
            {
              function()
                local bufnr = vim.api.nvim_get_current_buf()
                return require("arrow.statusline").text_for_statusline_with_icons(bufnr)
              end,
            },
          },
          lualine_x = { 'encoding' },
          lualine_y = {
            "filetype",
            {
              -- Show the current lsp
              icon = " ",
              lsp_name,
            },
            "progress",
          },
          lualine_z = {
            { 'location', separator = { right = '' }, left_padding = 2 },
          },
        },

        extensions = {'fugitive', 'nvim-tree'},  -- Optional extensions for git and nvim-tree
      })
  end
}
