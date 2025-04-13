return {
  'sheerun/vim-polyglot',
  lazy = false,

  config = function()
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*",
        callback = function()
          if vim.fn.exists("syntax_on") == 0 then
            vim.cmd("syntax enable")
          end
        end,
      })
  end,
}
