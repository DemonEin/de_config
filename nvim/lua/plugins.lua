-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'junegunn/fzf'

  use { 
	 'nvim-telescope/telescope.nvim', branch = '0.1.x',
	 requires = { { 'nvim-lua/plenary.nvim'} }
  }

  use { "catppuccin/nvim", as = "catppuccin" }

  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP

  use 'lewis6991/gitsigns.nvim'

  use 'tpope/vim-fugitive'

  -- use 'entrez/roku.vim'

  use 'nvim-treesitter/nvim-treesitter'

  use 'nvim-treesitter/nvim-treesitter-context'
end)
