return {

	{ 'vim-airline/vim-airline',
	opts = {},
	-- with Packer it didn't need a config funtion. Go figure...
	config = function()
		if not vim.g.airline_symbols then
			vim.g.airline_symbols = {}
		end

		-- vim-powerline symbols
		vim.g.airline_powerline_symbols = 1
		vim.g.airline_left_sep = ''
		vim.g.airline_left_alt_sep = ''
		vim.g.airline_right_sep = ''
		vim.g.airline_right_alt_sep = ''
	end,
	},
	'vim-airline/vim-airline-themes',
}
