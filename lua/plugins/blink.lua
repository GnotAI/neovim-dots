-- Set a global variable indicating if AI is enabled
if pcall(require, 'tabnine') then
  vim.g.ai_cmp = true  -- TabNine is available
else
  vim.g.ai_cmp = false -- TabNine is not available
end

return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "L3MON4D3/LuaSnip",
    {
      "saghen/blink.compat",
      optional = true,
    },
  },


  opts = {
    fuzzy = {
      implementation = "lua", -- Use Lua instead of Rust
    },
    snippets = {
      expand = function(snippet, _)
        require("luasnip").lsp_expand(snippet) -- Replace LazyVim.cmp.expand with LuaSnip
      end,
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          -- treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = {
        enabled = vim.g.ai_cmp or false,
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    cmdline = {
      enabled = false,
    },
    keymap = {
      preset = "enter",
      ["<C-y>"] = { "cancel" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

      ['<Tab>'] = { 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

      ["<C-j>"] = { 
        function()
          if require("blink.cmp").is_visible() then
            require("blink.cmp").select_next()
          end
        end,
      },
      ["<C-k>"] = {
        function()
          if require("blink.cmp").is_visible() then
            require("blink.cmp").select_prev()
          end
        end,
      },
    },
  },

  config = function(_, opts)
    require("blink.cmp").setup(opts)
  end
}
