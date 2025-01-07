-- Lualine configuration
require("lualine").setup({
  options = {
    -- theme = "everforest",  -- Set your desired theme here, e.g., 'everforest', 'gruvbox', etc.
    section_separators = {'', ''},  -- Rounded separators for sections
    component_separators = {'', ''},  -- Rounded separators for components inside sections
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff',  {
      'diagnostics',
      sources = {'nvim_lsp'},
      symbols = {error = ' ', warn = ' ', info = ' '},
      color = {fg = '#ff8800'},
    }},
    lualine_c = {'filename'},  -- LSP Status in center
    lualine_x = {'encoding', 'filetype', { 'lsp_clients', icon = ' ', }},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },
  extensions = {'fugitive', 'nvim-tree'},  -- Optional extensions for git and nvim-tree
})
