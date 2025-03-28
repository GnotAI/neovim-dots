return {    
  'numToStr/Comment.nvim',
  lazy = true, 
  keys = {'<leader>space'},

  config = function()
    require('Comment').setup()
  end
}
