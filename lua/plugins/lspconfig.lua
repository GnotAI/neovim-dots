return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Ensure nvim-lspconfig is installed
    local lspconfig = require('lspconfig')
    local jdtls_path = vim.fn.expand("~/.local/share/jdtls")
    local config_dir = jdtls_path .. "/config_linux"
    local workspace_dir = vim.fn.expand("~/.local/share/jdtls/workspace")
    local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

    -- Function to set up LSP keymaps
    local function lsp_keymaps(bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }

      -- Go to definition
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      -- Find references
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      -- Rename symbol
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      -- Show code actions
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    end

    -- Function to determine the root directory
    local function get_root_dir(fname, patterns)
      local root = lspconfig.util.root_pattern(unpack(patterns))(fname)
      return root or vim.fn.getcwd()
    end

    -- LSP Server Configurations
    local servers = {
      gopls = {
        cmd = { "gopls" },
        root_dir = function(fname)
          return get_root_dir(fname, { "go.mod", "go.sum" }) -- Require go.mod or go.sum
        end,
      },
      pylsp = {
        cmd = { "pylsp" },
        root_dir = function(fname)
          return get_root_dir(fname, { ".git", "setup.py", "pyproject.toml" }) -- Default to cwd if nothing found
          end,
      },
      ts_ls = {
         cmd = { "typescript-language-server", "--stdio" },
         root_dir = function(fname)
           return get_root_dir(fname, { ".git", "package.json", "tsconfig.json" }) -- Default to cwd if nothing found
           end,
      },
      lua_ls = {
         cmd = { "lua-language-server" },
         settings = {
           Lua = {
             runtime = {
               version = "LuaJIT",
               path = vim.split(package.path, ";"),
             },
             diagnostics = {
               globals = { "vim" }, -- Prevents "undefined global 'vim'" warning
             },
             workspace = {
               library = vim.api.nvim_get_runtime_file("", true),
               checkThirdParty = false, -- Avoid prompts about third-party libraries
             },
             telemetry = { enable = false },
           },
         },
         root_dir = function(fname)
           return get_root_dir(fname, { ".git", "init.lua", ".luarc.json", ".luacheckrc" }) -- customize if needed
           end,
      },
      clangd = {
         cmd = { "clangd" },
         root_dir = function(fname)
           return get_root_dir(fname, { "CMakeLists.txt", ".git" }) -- Default to cwd if nothing found
           end,
      },
      zls = {
         cmd = { "zls" },
         root_dir = function(fname)
           return get_root_dir(fname, { ".git", "build.zig" }) -- Default to cwd if nothing found
           end,
      },
      jdtls = {
           cmd = {
             "java", -- Make sure `java` is in PATH
             "-Declipse.application=org.eclipse.jdt.ls.core.id1",
             "-Dosgi.bundles.defaultStartLevel=4",
             "-Declipse.product=org.eclipse.jdt.ls.core.product",
             "-Dlog.level=ALL",
             "-Xms1g",
             "--add-modules=ALL-SYSTEM",
             "--add-opens", "java.base/java.util=ALL-UNNAMED",
             "--add-opens", "java.base/java.lang=ALL-UNNAMED",
             "-jar", launcher_jar,
               "-configuration", config_dir, -- or config_mac / config_win
               "-data", workspace_dir,
             },
             root_dir = function(fname)
              return get_root_dir(fname, {".git", "pom.xml", "build.gradle", "settings.gradle"})
             end,
      },

    }

           -- Set up each LSP
   for lsp, config in pairs(servers) do
     lspconfig[lsp].setup({
         cmd = config.cmd,
         root_dir = config.root_dir,
         on_attach = function(client, bufnr)
           lsp_keymaps(bufnr) -- Attach keymaps when the LSP starts
         end,
       })
   end
 end
}
