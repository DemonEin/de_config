-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'junegunn/fzf'

  use { 
	 'nvim-telescope/telescope.nvim', tag = '0.1.0',
	 requires = { { 'nvim-lua/plenary.nvim'} }
  }

  use { "catppuccin/nvim", as = "catppuccin" }

  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP

  use 'airblade/vim-gitgutter'

  use 'tpope/vim-fugitive'
end)
