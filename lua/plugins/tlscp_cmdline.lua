-- Telescope cmdline configuration
require("telescope").setup({
  -- ...
  extensions = {
    cmdline = {
      -- Adjust telescope picker size and layout
      picker = {
        layout_config = {
          width  = 120,
          height = 25,
        }
      },
      -- Adjust your mappings 
      mappings    = {
        complete      = '<Tab>',
        run_selection = '<C-CR>',
        run_input     = '<CR>',
      },
      -- Triggers any shell command using overseer.nvim (`:!`)
      overseer    = {
        enabled = true,
      },
    },
  }
})
