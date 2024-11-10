local cmp = require("cmp")
local npairs = require("nvim-autopairs")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)  -- Use LuaSnip
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),      -- Scroll docs up with Ctrl-b
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()  -- Select next completion item
      else
        cmp.mapping.scroll_docs(4)(fallback)  -- Scroll docs down
      end
    end, { "i", "s" }),  -- Enable in insert and select modes
    ["<C-Space>"] = cmp.mapping.complete(),       -- Trigger completion
    ["<C-e>"] = cmp.mapping.abort(),              -- Abort completion
    ["<CR>"] = cmp.mapping.confirm({ select = true }),  -- Confirm completion
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = string.format('   %s', vim_item.kind)
      vim_item.kind = ({
        Text = '',
        Method = 'ƒ',
        Function = '',
        Constructor = '',
        Field = 'ﰠ',
        Variable = '',
        Class = '',
        Interface = 'ﰮ',
        Module = '',
        Property = '',
        Unit = '',
        Value = '',
        Enum = '了',
        Keyword = '',
        Snippet = '﬌',
        Color = '',
        File = '',
        Reference = '',
        Folder = '',
        EnumMember = '',
        Constant = '',
        Struct = '',
        Event = '',
        Operator = 'ﬦ',
        TypeParameter = ''
      })[vim_item.kind]
      return vim_item
    end,
  },
  -- Automatically add brackets for function completions
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },
  experimental = {
    ghost_text = true,
  },

})

-- Setup nvim-autopairs
npairs.setup({
  check_ts = true,
})

-- Integrate nvim-autopairs with nvim-cmp for automatic function parentheses
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
'confirm_done',
cmp_autopairs.on_confirm_done()
)

-- Command-line mode setup
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" },
  }),
})
