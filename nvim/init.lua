require("plugins")

vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

require("catppuccin").setup()

require'lspconfig'.rust_analyzer.setup{}
require('lsp-config')

vim.cmd [[colorscheme catppuccin]]
vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.autowrite = true
vim.opt.autowriteall = true

-- keep cursor centered 
vim.opt.scrolloff = 9999

vim.opt.hlsearch = false
-- vim.opt.colorcolumn = '80'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- TODO look at 'columns' option

vim.opt.grepprg = "rg -n"

vim.g.mapleader = " "
local map = vim.api.nvim_set_keymap
map('n', '<C-p>', ':Telescope find_files<cr>', {noremap = true})  

-- copied from https://stackoverflow.com/questions/63906439/how-to-disable-line-numbers-in-neovim-terminal
-- autocommands
--- This function is taken from https://github.com/norcalli/nvim_utils

local api = vim.api
function nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    api.nvim_command('augroup '..group_name)
    api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      api.nvim_command(command)
    end
    api.nvim_command('augroup END')
  end
end

local autocmds = {
    terminal_job = {
        -- consider these
        -- { "TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]] };
        -- { "TermOpen", "*", "startinsert" };
        { "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" };
    };
}

nvim_create_augroups(autocmds)
-- autocommands END
