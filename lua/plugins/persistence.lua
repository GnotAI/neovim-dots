return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- Load the plugin on buffer read
  config = function()
    require("persistence").setup({
      dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"), -- Save sessions in this directory
      options = { "buffers", "curdir", "tabpages", "winsize" }, -- What to store in the session
    })
  end,
}
