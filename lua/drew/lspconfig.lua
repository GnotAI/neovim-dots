-- LSP configuration
local autocmd = vim.api.nvim_create_autocmd
-- LSP Servers and their file patterns
local lsp_servers = {
    go = { lsp = 'gopls', pattern = 'go' },
    python = { lsp = 'pylsp', pattern = 'python' },
    javascript = { lsp = 'typescript-language-server', pattern = { 'javascript', 'typescript' } },
    html = { lsp = 'vscode-html-languageserver', pattern = {'html', 'htmldjango'} },
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
    elseif filetype == 'html' or filetype == 'tailwindcss' or filetype == 'htmldjango' then
        root_dir = vim.fs.dirname(vim.fs.find({ 'tailwind.config.js', 'index.html', 'package.json' }, { upward = true })[1]) or vim.fn.getcwd()
    elseif filetype == 'c' or filetype == 'cpp' then
        root_dir = vim.fs.dirname(vim.fs.find({ 'CMakeLists.txt', '.git' }, { upward = true })[1])
    else
        root_dir = vim.fn.getcwd()
    end

    local cmd = { "typescript-language-server", "--stdio" }
    if filetype ~= 'javascript' and filetype ~= 'typescript' then
        cmd = { server.lsp }  -- Fallback to the server for other filetypes
    end

    local client = vim.lsp.start({
        name = server.lsp,
        cmd = cmd,
        root_dir = root_dir,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
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

