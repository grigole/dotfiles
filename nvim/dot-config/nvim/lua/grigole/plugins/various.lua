return {

	-- See `:help gitsigns` to understand what the configuration keys do
	-- Adds git related signs to the gutter, as well as utilities for managing changes
	{ 'lewis6991/gitsigns.nvim',
	opts = {
		signs = {
			add = { text = '+' },
			change = { text = '~' },
			delete = { text = '_' },
			topdelete = { text = '‾' },
			changedelete = { text = '~' },
		},
	},
	},

	-- Highlight todo, notes, etc in comments
	{ 'folke/todo-comments.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {
			highlight = {
				keyword = "bg",
			}
		},
	},

	{ -- Collection of various small independent plugins/modules
	'echasnovski/mini.nvim',
	config = function()
		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [']quote
		--  - ci'  - [C]hange [I]nside [']quote
		require('mini.ai').setup { n_lines = 500 }

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		require('mini.surround').setup()
	end,
},

}
