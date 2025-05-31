-- Mostly copied from https://lazy.folke.io/installation

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { 
            "nvim-telescope/telescope.nvim",
            branch = "0.1.x",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
        { "catppuccin/nvim", name = "catppuccin" },
        { "lewis6991/gitsigns.nvim" },
        { "tpope/vim-fugitive" },
        { "nvim-treesitter/nvim-treesitter" },
        { "nvim-treesitter/nvim-treesitter-context" },
        {
            "stevearc/oil.nvim",
            dependencies = { { "echasnovski/mini.icons", {} } },
            -- Lazy loading is not recommended because it is very tricky to make
            -- it work correctly in all situations.
            lazy = false,
        },
        { "nvim-tree/nvim-web-devicons" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    rocks = {
        enabled = false,
    },
    install = { colorscheme = { "catppuccin" } },
    -- automatically check for plugin updates
    checker = {
        enabled = true,
        notify = false,
    },
})
