local o = vim.opt

vim.cmd("set expandtab")
vim.cmd("set shiftwidth=2")
vim.cmd("set tabstop=2")

-- Options
o.cmdheight = 0
o.number = true
o.swapfile = false
o.relativenumber = true
o.termguicolors = true
o.undofile = true  -- Turn on persistent undo
o.undodir = os.getenv("HOME") .. "/.config/nvim/undo"  -- Set the undo directory

-- External file configs
require("drew.lazy")
require("drew.lspconfig")
require("drew.mappings")
require("plugins.init")

