--
-- LazyVim
--
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

--
-- General options
-- 
vim.g.mapleader = ' '
vim.g.maplocalleader = '  '

vim.o.clipboard = "unnamedplus"
vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.wo.number = true
vim.o.mouse = 'a'
vim.o.undofile = true
vim.o.termguicolors = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'i', 'n', 'v' }, '<c-k>', '<esc>', { desc = 'Escape' })
vim.keymap.set( 'n', '<leader>yp', '"0p', { desc = 'Quit window' })

vim.keymap.set('n', '<leader>/q', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlights' })
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save buffer' })
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>', { desc = 'Quit window' })

--
-- Highlight yank
--
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

--
-- Return to the last cursor position when opening a file
--
vim.api.nvim_create_autocmd('BufReadPost', {
	callback = function()
		vim.api.nvim_exec('silent! normal! g`"zv', false)
	end,
	pattern = { "*" },
})

--
-- Plugins
--
require('lazy').setup({
	-- 'folke/which-key.nvim',

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end
	},

	{
		"chentoast/marks.nvim",
		event = "VeryLazy",
		opts = {},
	},

	{
		-- TODO: refresh signs on save
		'lewis6991/gitsigns.nvim',	
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					vim.keymap.set('n', '<leader>gp', gs.preview_hunk,
					{ buffer = bufnr, desc = 'Preview git hunk' })
					vim.keymap.set('n', '<leader>gb', gs.blame_line,
					{ buffer = bufnr, desc = 'Git blame line' })

					vim.keymap.set({ 'n', 'v' }, '<leader>gj', function()
						if vim.wo.diff then
							return '<leader>gj'
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return '<Ignore>'
					end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
					vim.keymap.set({ 'n', 'v' }, '<leader>gk', function()
						if vim.wo.diff then
							return '<leader>gk'
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return '<Ignore>'
					end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
				end,
			})
		end,
	},

	-- {
		-- 	'dstein64/nvim-scrollview',
		-- 	config = function()
		-- 		require('scrollview').setup({
			-- 			current_only = true,
			-- 			base = 'buffer',
			-- 			column = 120,
			-- 			signs_on_startup = {'all'},
			-- 			diagnostics_severities = {vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN}
			-- 		})

			-- 		require('scrollview.contrib.gitsigns').setup()
			-- 	end,
	-- },

	{
		'navarasu/onedark.nvim',
		priority = 1000,
		config = function()
			vim.cmd.colorscheme 'onedark'
		end,
	},

	{
		'nvim-lualine/lualine.nvim',
		opts = {
			options = {
				icons_enabled = false,
				theme = 'onedark',
				component_separators = '|',
				section_separators = '',
			},
		},
	},
})

--
-- LSPs
--
servers = {
	texlab = {
		cmd = { 'texlab' },
		filetypes = { 'tex', 'bib' },
		root_markers = { '.git' },
		settings = {},
	},
	pyright = {
		cmd = { 'pyright' },
		filetypes = { 'py' },
		root_markers = { '.git', 'env', '.env' },
		settings = {},
	},
}

for name, server in pairs(servers) do
	vim.lsp.config(name, server)
	vim.lsp.enable(name)
end
