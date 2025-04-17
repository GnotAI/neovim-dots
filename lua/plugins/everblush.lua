return {
  "srt0/everblush.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("everblush").setup({
      transparent = true,
    })
  end,
}
