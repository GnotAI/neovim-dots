vim.cmd("set expandtab")
vim.cmd("set shiftwidth=2")
vim.cmd("set softtabstop=2")
vim.cmd("set tabstop=2")

vim.opt.undofile = true  -- Turn on persistent undo
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undo"  -- Set the undo directory

require("drew.lazy")
require("drew.lspconfig")
require("drew.mappings")
require("drew.options")
require("plugins.init")
