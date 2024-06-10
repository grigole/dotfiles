
return {

	{ 'stevearc/oil.nvim',

	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require('oil').setup {
			columns = { "icon" },
			keymaps = {
				["<C-h>"] = false,
				["<M-h>"] = "actions.select_split",
			},
			view_options = {
				show_hidden = true,
			},
			-- Allow netrw to work with <leader>pv
			default_file_explorer = false,
		}

		vim.keymap.set( "n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" } );
		vim.keymap.set( "n", "<leader>-", require('oil').toggle_float );

	end,
},

}
