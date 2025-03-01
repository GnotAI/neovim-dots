-- LSP STATUS
-- local function lsp_name()
-- 	local name = "No Active Lsp"
-- 	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
-- 	local clients = vim.lsp.get_clients()
-- 	if next(clients) == nil then
-- 		return name
-- 	end
-- 	for _, client in ipairs(clients) do
-- 		local filetypes = client.config.filetypes
-- 		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
-- 			return client.name
-- 		end
-- 	end
-- 	return name
-- end
--

_G.custom_winbar = function()
  local filepath = vim.fn.expand('%:p') -- Get full file path
  local filename = vim.fn.expand('%:t') -- Get only the filename
  local filetype = vim.bo.filetype       -- Get file type

  -- Replace `/` with ` > `
  local formatted_path = filepath:gsub('^/', ''):gsub('/', ' > ')

  -- Get file type icon
  local devicons = require('nvim-web-devicons')
  local icon = devicons.get_icon(filename, vim.fn.expand('%:e'), { default = true })

  return formatted_path
end

-- Set the winbar globally so it stays constant in all splits
vim.o.winbar = "%{%v:lua.custom_winbar()%}"

-- Set winbar highlight to match the normal editor background
vim.api.nvim_command("highlight WinBar guibg=NONE guifg=NONE")
vim.api.nvim_command("highlight WinBarNC guibg=NONE guifg=NONE") 

local function lsp_name()
    local clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
    if #clients == 0 then
        return "No Active LSP"
    end

    -- Concatenate all client names for the buffer
    local client_names = {}
    for _, client in ipairs(clients) do
        table.insert(client_names, client.name)
    end
    return table.concat(client_names, ", ")
end

local function path()
	local pwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	local sub_path = vim.fn.expand("%:~:.:h")

	if sub_path:match("oil") then
		local oil_pattern = "oil://" .. vim.fn.getcwd()
		sub_path = sub_path:gsub(oil_pattern, "")
	else
		pwd = pwd .. ">"
	end

	if sub_path:len() > 40 then
		return pwd .. vim.fn.pathshorten(sub_path)
	end
	return pwd .. sub_path
end

-- Lualine configuration
require("lualine").setup({
  options = {
    theme = everforest,
    component_separators = '|',
    section_separators = { left = '', right = '' },
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      { 'mode' },
    },
    lualine_b = { 'branch', 'diff' },
    lualine_c = {
              -- {
              --   -- get_project_root,
              --   path,
              --   icon = " ",
              --   separator = "",
              -- },
             "diagnostics",
              {
                function()
                  local bufnr = vim.api.nvim_get_current_buf()
                  return require("arrow.statusline").text_for_statusline_with_icons(bufnr)
                end,
              },
            },
    lualine_x = { 'encoding' },
    lualine_y = {
              "filetype",
              {
                -- Show the current lsp
                icon = " ",
                lsp_name,
              },
               "progress",
            },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },

  -- inactive_sections = {
  --   lualine_a = { 'filename' },
  --   lualine_b = {},
  --   lualine_c = {},
  --   lualine_x = {},
  --   lualine_y = {},
  --   lualine_z = { 'location' },
  -- },
  tabline = {},
  extensions = {'fugitive', 'nvim-tree'},  -- Optional extensions for git and nvim-tree
})

