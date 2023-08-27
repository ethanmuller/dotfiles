-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'
    use "christoomey/vim-tmux-navigator"
	-- use({ 'rose-pine/neovim', as = 'rose-pine' })
    --use('folke/tokyonight.nvim')
    -- use('preservim/vim-colors-pencil')
    --use('jsit/toast.vim')
    -- vim.opt.background = 'light'
    vim.cmd('colorscheme rose-pine')

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}

  use 'rust-lang/rust.vim'
  use 'timonv/vim-cargo'
	use 'nvim-treesitter/playground'
	use('mbbill/undotree')
	use('tpope/vim-fugitive')
	use('tpope/vim-surround')
	use('tpope/vim-commentary')
  use('kien/ctrlp.vim')
  use('AndrewRadev/switch.vim')
  use('tommcdo/vim-lion')
  use('stevearc/vim-arduino')
  use('wfxr/minimap.vim')
  use ('tikhomirov/vim-glsl')
  use ('yuezk/vim-js')
  use ('HerringtonDarkholme/yats.vim')
  use ('maxmellon/vim-jsx-pretty')
  use ('prettier/vim-prettier')

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{                                      -- Optional
				'williamboman/mason.nvim',
				run = function()
					pcall(vim.cmd, 'MasonUpdate')
				end,
			},
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},     -- Required
			{'hrsh7th/cmp-nvim-lsp'}, -- Required
			{'L3MON4D3/LuaSnip'},     -- Required
		}
	}
end)
