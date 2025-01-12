-- Everforest themeing 
require("everforest").setup({
  background = "medium",      -- Options: 'hard', 'medium', 'soft'
  transparent_background = false,  -- Set to true if you want transparency
  italics = true,             -- Use italic text where applicable
  disable_italic_comments = true,  -- Disable italics in comments if preferred
  ui_contrast = "high",       -- Options: 'low', 'normal', 'high'
})

-- colorscheme to use
vim.cmd("colorscheme noctis_minimus")

