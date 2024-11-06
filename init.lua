vim.cmd("set expandtab")
vim.cmd("set shiftwidth=2")
vim.cmd("set softtabstop=2")
vim.cmd("set tabstop=2")
vim.opt.undofile = true  -- Turn on persistent undo
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undo"  -- Set the undo directory

require("drew.lazy")
require("drew.mappings")
require("drew.options")

-- Treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "typescript", "go", "python", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- Everforest themeing 
require("everforest").setup({
  background = "medium",      -- Options: 'hard', 'medium', 'soft'
  transparent_background = false,  -- Set to true if you want transparency
  italics = true,             -- Use italic text where applicable
  disable_italic_comments = true,  -- Disable italics in comments if preferred
  ui_contrast = "high",       -- Options: 'low', 'normal', 'high'
})

vim.cmd("colorscheme everforest")

-- Lualine configuration
require("lualine").setup({
  options = {
    theme = "everforest",  -- Set your desired theme here, e.g., 'everforest', 'gruvbox', etc.
    section_separators = {'', ''},  -- Rounded separators for sections
    component_separators = {'', ''},  -- Rounded separators for components inside sections
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},  -- LSP Status in center
    lualine_x = {'encoding', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },
  extensions = {'fugitive', 'nvim-tree'},  -- Optional extensions for git and nvim-tree
})

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


-- LSP configuration
local autocmd = vim.api.nvim_create_autocmd
-- LSP Servers and their file patterns
local lsp_servers = {
    go = { lsp = 'gopls', pattern = 'go' },
    python = { lsp = 'pylsp', pattern = 'python' },
    javascript = { lsp = 'eslint', pattern = 'javascript' },
    typescript = { lsp = 'eslint', pattern = 'typescript' },
    html = { lsp = 'html', pattern = {'html', 'htmldjango'} },
    tailwindcss = { lsp = 'tailwindcss', pattern = {'html', 'htmldjango'} }, -- Can also use 'css' or 'javascript'
    c = { lsp = 'clangd', pattern = 'c' },
    cpp = { lsp = 'clangd', pattern = 'cpp' },
}

-- Function to handle LSP attachment
local function attach_lsp(filetype)
    local server = lsp_servers[filetype]
    if not server then return end

    local root_dir = vim.fs.dirname(
        vim.fs.find({ '.git' }, { upward = true })[1] -- Default to looking for .git directory
    )

    if filetype == 'go' then
        root_dir = vim.fs.dirname(vim.fs.find({ 'go.mod', 'go.work' }, { upward = true })[1])
    elseif filetype == 'typescript' or filetype == 'javascript' then
        root_dir = vim.fs.dirname(vim.fs.find({ 'tsconfig.json', 'package.json' }, { upward = true })[1])
    elseif filetype == 'html' or filetype == 'tailwindcss' or filetype == 'htmldjango' then
        root_dir = vim.fs.dirname(vim.fs.find({ 'tailwind.config.js', 'index.html', 'package.json' }, { upward = true })[1]) or vim.fn.getcwd()
    elseif filetype == 'c' or filetype == 'cpp' then
        root_dir = vim.fs.dirname(vim.fs.find({ 'CMakeLists.txt', '.git' }, { upward = true })[1])
    else
        root_dir = vim.fn.getcwd()
    end

    local client = vim.lsp.start({
        name = server.lsp,
        cmd = { server.lsp },
        root_dir = root_dir,
    })

    vim.lsp.buf_attach_client(0, client)
end

-- Auto command for all the specified file types
autocmd("FileType", {
    pattern = { "go", "python", "javascript", "typescript", "html", "c", "cpp" },
    callback = function()
        attach_lsp(vim.bo.filetype)
    end
})

require("telescope").setup({
  -- ...
  extensions = {
    cmdline = {
      -- Adjust telescope picker size and layout
      picker = {
        layout_config = {
          width  = 120,
          height = 25,
        }
      },
      -- Adjust your mappings 
      mappings    = {
        complete      = '<Tab>',
        run_selection = '<C-CR>',
        run_input     = '<CR>',
      },
      -- Triggers any shell command using overseer.nvim (`:!`)
      overseer    = {
        enabled = true,
      },
    },
  }
})
