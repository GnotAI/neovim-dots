-- Options
local o = vim.opt

o.termguicolors = true

o.cmdheight = 0
o.swapfile = false

o.number = true
o.relativenumber = true

o.undofile = true  -- Turn on persistent undo
o.undodir = os.getenv("HOME") .. "/.config/nvim/undo"  -- Set the undo directory

o.foldcolumn = "1"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true

-- External file configs
require("drew.lazy")
require("drew.mappings")
require("autocmds")

-- Commands 
vim.cmd.set("expandtab")
vim.cmd.set("shiftwidth=2")
vim.cmd.set("tabstop=2")
vim.cmd.colorscheme("everblush")
