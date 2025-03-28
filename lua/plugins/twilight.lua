return {
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
  end
}
