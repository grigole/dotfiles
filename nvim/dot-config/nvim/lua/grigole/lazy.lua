-- Load lazy.nvim from github if not already installed
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
	-- NOTE: Install plugins here.
	--

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
{ 'vim-airline/vim-airline-themes' },

{ 'j-hui/fidget.nvim' },

-- Useful for getting pretty icons, but requires special font.
--  If you already have a Nerd Font, or terminal set up with fallback fonts
--  you can enable this
{ 'nvim-tree/nvim-web-devicons' },

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

	-- Eye-Candy
	-- { "catppuccin/nvim", as = "catppuccin" },

	{ "mbbill/undotree" },
	{ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
	{ 'nvim-treesitter/playground' },
	{ 'tpope/vim-fugitive' },

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
	{ 'nvim-telescope/telescope-ui-select.nvim' },
},

{ "ThePrimeagen/harpoon",
branch = "harpoon2",
dependencies = {"nvim-lua/plenary.nvim"},
	},

	{ -- LSP Configuration & Plugins
	'neovim/nvim-lspconfig',
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for neovim
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'WhoIsSethDaniel/mason-tool-installer.nvim',

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ 'j-hui/fidget.nvim', opts = {} },
	},
	config = function()
		-- Brief Aside: **What is LSP?**
		--
		-- LSP is an acronym you've probably heard, but might not understand what it is.
		--
		-- LSP stands for Language Server Protocol. It's a protocol that helps editors
		-- and language tooling communicate in a standardized fashion.
		--
		-- In general, you have a "server" which is some tool built to understand a particular
		-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc). These Language Servers
		-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
		-- processes that communicate with some "client" - in this case, Neovim!
		--
		-- LSP provides Neovim with features like:
		--  - Go to definition
		--  - Find references
		--  - Autocompletion
		--  - Symbol Search
		--  - and more!
		--
		-- Thus, Language Servers are external tools that must be installed separately from
		-- Neovim. This is where `mason` and related plugins come into play.
		--
		-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
		-- and elegantly composed help section, `:help lsp-vs-treesitter`

		--  This function gets run when an LSP attaches to a particular buffer.
		--    That is to say, every time a new file is opened that is associated with
		--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
		--    function will be executed to configure the current buffer
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
			callback = function(event)
				-- NOTE: Remember that lua is a real programming language, and as such it is possible
				-- to define small helper and utility functions so you don't have to repeat yourself
				-- many times.
				--
				-- In this case, we create a function that lets us more easily define mappings specific
				-- for LSP related items. It sets the mode, buffer and description for us each time.
				local map = function(keys, func, desc)
					vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
				end

				-- Jump to the definition of the word under your cursor.
				--  This is where a variable was first declared, or where a function is defined, etc.
				--  To jump back, press <C-T>.
				map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

				-- Find references for the word under your cursor.
				map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

				-- Jump to the implementation of the word under your cursor.
				--  Useful when your language has ways of declaring types without an actual implementation.
				map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

				-- Jump to the type of the word under your cursor.
				--  Useful when you're not sure what type a variable is and you want to see
				--  the definition of its *type*, not where it was *defined*.
				map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

				-- Fuzzy find all the symbols in your current document.
				--  Symbols are things like variables, functions, types, etc.
				map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

				-- Fuzzy find all the symbols in your current workspace
				--  Similar to document symbols, except searches over your whole project.
				map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

				-- Rename the variable under your cursor
				--  Most Language Servers support renaming across files, etc.
				map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

				-- Opens a popup that displays documentation about the word under your cursor
				--  See `:help K` for why this keymap
				map('K', vim.lsp.buf.hover, 'Hover Documentation')

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				--  For example, in C this would take you to the header
				map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
						buffer = event.buf,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
						buffer = event.buf,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end,
		})

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP Specification.
		--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. Available keys are:
		--  - cmd (table): Override the default command used to start the server
		--  - filetypes (table): Override the default list of associated filetypes for the server
		--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		--  - settings (table): Override the default settings passed when initializing the server.
		--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
		local servers = {
			-- clangd = {},
			-- gopls = {},
			-- pyright = {},
			-- rust_analyzer = {},
			-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
			--
			-- Some languages (like typescript) have entire language plugins that can be useful:
			--    https://github.com/pmizio/typescript-tools.nvim
			--
			-- But for many setups, the LSP (`tsserver`) will work just fine
			-- tsserver = {},
			--

			lua_ls = {
				-- cmd = {...},
				-- filetypes { ...},
				-- capabilities = {},
				settings = {
					Lua = {
						runtime = { version = 'LuaJIT' },
						workspace = {
							checkThirdParty = false,
							-- Tells lua_ls where to find all the Lua files that you have loaded
							-- for your neovim configuration.
							library = {
								'${3rd}/luv/library',
								unpack(vim.api.nvim_get_runtime_file('', true)),
							},
							-- If lua_ls is really slow on your computer, you can try this instead:
							-- library = { vim.env.VIMRUNTIME },
						},
						completion = {
							callSnippet = 'Replace',
						},
						-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						diagnostics = { disable = { 'missing-fields' } },
					},
				},
			},
		}

		-- Ensure the servers and tools above are installed
		--  To check the current status of installed tools and/or manually install
		--  other tools, you can run
		--    :Mason
		--
		--  You can press `g?` for help in this menu
		require('mason').setup( {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗"
				}
			}
		})

		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			'stylua', -- Used to format lua code
		})
		require('mason-tool-installer').setup { ensure_installed = ensure_installed }

		require('mason-lspconfig').setup {
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for tsserver)
					server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
					require('lspconfig')[server_name].setup(server)
				end,
			},
		}
	end
},

{ -- Autocompletion
'hrsh7th/nvim-cmp',
event = 'InsertEnter',
dependencies = {
	-- Snippet Engine & its associated nvim-cmp source
	{
		'L3MON4D3/LuaSnip',
		build = (function()
			-- Build Step is needed for regex support in snippets
			-- This step is not supported in many windows environments
			-- Remove the below condition to re-enable on windows
			if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
				return
			end
			return 'make install_jsregexp'
		end)(),
	},
	'saadparwaiz1/cmp_luasnip',

	-- Adds other completion capabilities.
	--  nvim-cmp does not ship with all sources by default. They are split
	--  into multiple repos for maintenance purposes.
	'hrsh7th/cmp-nvim-lua',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',

	-- If you want to add a bunch of pre-configured snippets,
	--    you can use this plugin to help you. It even has snippets
	--    for various frmeworks/libraries/etc. but you will have to
	--    set up the ones that are useful for you.
	-- 'rafamadriz/friendly-snippets',
},
config = function()
	-- See `:help cmp`
	local cmp = require 'cmp'
	local luasnip = require 'luasnip'
	luasnip.config.setup {}

	cmp.setup {
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		completion = { completeopt = 'menu,menuone,noinsert' },

		-- For an understanding of why these mappings were
		-- chosen, you will need to read `:help ins-completion`
		--
		-- No, but seriously. Please read `:help ins-completion`, it is really good!
		mapping = cmp.mapping.preset.insert {
			-- Select the [n]ext item
			['<C-n>'] = cmp.mapping.select_next_item(),
			-- Select the [p]revious item
			['<C-p>'] = cmp.mapping.select_prev_item(),

			-- Accept ([y]es) the completion.
			--  This will auto-import if your LSP supports it.
			--  This will expand snippets if the LSP sent a snippet.
			['<C-y>'] = cmp.mapping.confirm { select = true },

			-- Manually trigger a completion from nvim-cmp.
			--  Generally you don't need this, because nvim-cmp will display
			--  completions whenever it has completion options available.
			['<C-Space>'] = cmp.mapping.complete {},

			-- Think of <c-l> as moving to the right of your snippet expansion.
			--  So if you have a snippet that's like:
			--  function $name($args)
			--    $body
			--  end
			--
			-- <c-l> will move you to the right of each of the expansion locations.
			-- <c-h> is similar, except moving you backwards.
			['<C-l>'] = cmp.mapping(function()
				if luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				end
			end, { 'i', 's' }),
			['<C-h>'] = cmp.mapping(function()
				if luasnip.locally_jumpable(-1) then
					luasnip.jump(-1)
				end
			end, { 'i', 's' }),
		},
		sources = {
			{ name = 'nvim_lsp' },
			{ name = 'luasnip' },
			{ name = 'path' },
		},
	}
end,
	},

	-- Highlight todo, notes, etc in comments
	{ 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

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

		-- Simple and easy statusline.
		--  You could remove this setup call if you don't like it,
		--  and try some other statusline plugin
		local statusline = require 'mini.statusline'
		statusline.setup()

		-- You can configure sections in the statusline by overriding their
		-- default behavior. For example, here we set the section for
		-- cursor location to LINE:COLUMN
		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			return '%2l:%-2v'
		end

		-- ... and there is more!
		--  Check out: https://github.com/echasnovski/mini.nvim
	end,
},
-- Various nerd fonts
{ 'ryanoasis/vim-devicons' },

{ 'mfussenegger/nvim-dap',

dependencies = {
	-- Creates a beautiful debugger UI
	'rcarriga/nvim-dap-ui',
	-- This was suddenly required by an update on Mar 23 2024...
	'nvim-neotest/nvim-nio',

	-- Installs the debug adapters for you
	'williamboman/mason.nvim',
	'jay-babu/mason-nvim-dap.nvim',

	-- Add your own debuggers here
	'leoluz/nvim-dap-go',
},
config = function()
	local dap = require 'dap'
	local dapui = require 'dapui'

	require('mason-nvim-dap').setup {
		-- Makes a best effort to setup the various debuggers with
		-- reasonable debug configurations
		automatic_setup = true,

		-- You can provide additional configuration to the handlers,
		-- see mason-nvim-dap README for more information
		handlers = {},

		-- You'll need to check that you have the required things installed
		-- online, please don't ask me how to install them :)
		ensure_installed = {
			-- Update this to ensure that you have the debuggers for the langs you want
			'delve',
		},
	}

	-- Basic debugging keymaps, feel free to change to your liking!
	vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
	vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
	vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
	vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
	vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
	vim.keymap.set('n', '<leader>B', function()
		dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
	end, { desc = 'Debug: Set Breakpoint' })

	-- Dap UI setup
	-- For more information, see |:help nvim-dap-ui|
	dapui.setup {
		-- Set icons to characters that are more likely to work in every terminal.
		--    Feel free to remove or use ones that you like more! :)
		--    Don't feel like these are good choices.
		icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
		controls = {
			icons = {
				pause = '⏸',
				play = '▶',
				step_into = '⏎',
				step_over = '⏭',
				step_out = '⏮',
				step_back = 'b',
				run_last = '▶▶',
				terminate = '⏹',
				disconnect = '⏏',
			},
		},
	}

	-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
	vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

	dap.listeners.after.event_initialized['dapui_config'] = dapui.open
	dap.listeners.before.event_terminated['dapui_config'] = dapui.close
	dap.listeners.before.event_exited['dapui_config'] = dapui.close

	-- Install golang specific config
	require('dap-go').setup()
end,
}
}
