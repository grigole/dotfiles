
return {

	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		event = 'VimEnter',
		dependencies = {'nvim-lua/plenary.nvim'},
		{ -- If encountering errors, see telescope-fzf-native README for install instructions
		'nvim-telescope/telescope-fzf-native.nvim',

		-- `build` is used to run some command when the plugin is installed/updated.
		-- This is only run then, not every time Neovim starts up.
		build = 'make',

		-- `cond` is a condition used to determine whether this plugin should be
		-- installed and loaded.
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
	},

	'nvim-telescope/telescope-ui-select.nvim',
	'jvgrootveld/telescope-zoxide',
	'tsakirist/telescope-lazy.nvim',
	'AckslD/nvim-neoclip.lua',
	'xiyaowong/telescope-emoji.nvim',
	'doctorfree/cheatsheet.nvim',
},

}
