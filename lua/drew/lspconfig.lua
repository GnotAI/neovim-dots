-- Ensure 'lspconfig' is available
local lspconfig = require('lspconfig')

-- Go (gopls)
lspconfig.gopls.setup({
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        unreachable = true,
      },
      staticcheck = true,
    },
  },
})

-- Python (pyright)
lspconfig.pyright.setup({
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- TypeScript (tsserver)
lspconfig.tsserver.setup({
  settings = {
    javascript = {
      format = { enable = true },
    },
    typescript = {
      format = { enable = true },
    },
  },
})

-- C++ (clangd)
lspconfig.clangd.setup({
  cmd = { "clangd", "--background-index" }, -- You can add flags if needed
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = lspconfig.util.root_pattern(".clangd", "compile_commands.json", ".git"),
})

-- HTML (html-languageserver)
lspconfig.html.setup({
  cmd = { "html-languageserver", "--stdio" },
  filetypes = { "html", "css", "javascript" },
})

-- TailwindCSS (tailwindcss-language-server)
lspconfig.tailwindcss.setup({
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = { "html", "css", "javascript", "typescript" },
})
