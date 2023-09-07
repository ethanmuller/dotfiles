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

require('lazy').setup({
  'christoomey/vim-tmux-navigator',

  {
    'rose-pine/neovim', as = 'rose-pine',
    config = function()
      vim.cmd("colorscheme rose-pine")
    end
  }, 

  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',
  'neovim/nvim-lspconfig',
  'rust-lang/rust.vim',
  'timonv/vim-cargo',
  'mbbill/undotree',
  'tpope/vim-fugitive',
  'tpope/vim-surround',
  'tpope/vim-commentary',
  'kien/ctrlp.vim',
  'AndrewRadev/switch.vim',
  'tommcdo/vim-lion',
  'stevearc/vim-arduino',
  'tikhomirov/vim-glsl',
  'yuezk/vim-js',
  'HerringtonDarkholme/yats.vim',
  'maxmellon/vim-jsx-pretty',
  'prettier/vim-prettier',
  'tpope/vim-markdown',
  'tidalcycles/vim-tidal',

})
