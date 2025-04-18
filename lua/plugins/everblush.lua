return {
  "srt0/everblush.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("codescope").setup({
      transparent = true,
    })
  end,
}
