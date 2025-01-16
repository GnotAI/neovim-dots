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
		pwd = pwd .. "/"
	end

	if sub_path:len() > 40 then
		return pwd .. vim.fn.pathshorten(sub_path)
	end
	return pwd .. sub_path
end

-- Custom noctis_minimus theme for lualine
local noctis_minimus = {
  normal = {
    a = { fg = '#ffffff', bg = '#1e1e28', gui = 'bold' },
    b = { fg = '#c5c8c6', bg = '#282a36' },
    c = { fg = '#ffffff', bg = '#1e1e28' },
  },
  insert = { a = { fg = '#ffffff', bg = '#519f50', gui = 'bold' } },
  visual = { a = { fg = '#ffffff', bg = '#cc241d', gui = 'bold' } },
  replace = { a = { fg = '#ffffff', bg = '#d65d0e', gui = 'bold' } },
  command = { a = { fg = '#ffffff', bg = '#458588', gui = 'bold' } },
  inactive = {
    a = { fg = '#c5c8c6', bg = '#282a36', gui = 'bold' },
    b = { fg = '#c5c8c6', bg = '#1e1e28' },
    c = { fg = '#c5c8c6', bg = '#1e1e28' },
  },
}

-- Lualine configuration
require("lualine").setup({
  options = {
    theme = noctis_minimus,
    component_separators = '|',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      { 'mode' },
    },
    lualine_b = { 'branch', 'diff' },
    lualine_c = {
              {
                -- get_project_root,
                path,
                icon = " ",
                separator = "",
              },
              {
                "filetype",
                icon_only = true,
                padding = { left = 2, right = 0 },
              },
              {
                "filename",
                file_status = true, -- displays file status (readonly status, modified status)
                path = 0, -- Only filename
                symbols = {
                  newfile = "", -- Icon to show when the file is new.
                  readonly = "", -- Icon to show when the file is read only.
                  unnamed = "", -- No icon to show when the file is unnamed.
                  modified = "", -- Icon to show when the file is modified.
                },
              },
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

