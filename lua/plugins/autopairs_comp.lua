-- Autopairs completions
require("nvim-autopairs").setup({
  check_ts = true,  -- Enable tree-sitter-based syntax checking for pairs
  fast_wrap = {
    map = "<M-e>",  -- Shortcut to quickly wrap selected text with pairs (e.g., brackets)
    chars = { "(", "{", "[", '"', "'" },
    pattern = string.gsub([[ [%'%"%>%)%]%-] ]], "%s", ""),
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
  },
})

-- Automatically pairs brackets, quotes, etc. when typing
require("nvim-autopairs").setup({
  map_cr = true,  -- Enable Enter key completion (e.g., for closing brackets)
  map_complete = true,
})
