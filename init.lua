-- Options
local o = vim.opt

o.cmdheight = 0
o.number = true
o.swapfile = false
o.relativenumber = true
o.termguicolors = true
o.undofile = true  -- Turn on persistent undo
o.undodir = os.getenv("HOME") .. "/.config/nvim/undo"  -- Set the undo directory

-- External file configs
require("drew.lazy")
require("drew.mappings")

-- Commands 
vim.cmd("set expandtab")
vim.cmd("set shiftwidth=2")
vim.cmd("set tabstop=2")
