-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use({
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end
	})

	use( 'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'} )
	use( 'nvim-treesitter/playground' )

	use {
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { {"nvim-lua/plenary.nvim"} }
	}

	use( 'mbbill/undotree' )
	use( 'tpope/vim-fugitive' )

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			{'saadparwaiz1/cmp_luasnip'},
			{'hrsh7th/cmp-nvim-lua'},
			{'L3MON4D3/LuaSnip'},
			{'rafamadriz/friendly-snippets'},
		}
	}

	-- Eye-Candy
	use( 'vim-airline/vim-airline' )
	use( 'j-hui/fidget.nvim' )
	use{ "catppuccin/nvim", as = "catppuccin" }

	use( 'christoomey/vim-tmux-navigator')

	-- Debugging
	use 'mfussenegger/nvim-dap'
	use 'rcarriga/nvim-dap-ui'
	use	'nvim-telescope/telescope-dap.nvim'
	use 'theHamsta/nvim-dap-virtual-text'
	use 'leoluz/nvim-dap-go'

end)
