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

vim.cmd('set clipboard+=unnamedplus')

-- keep cursor centered 
vim.opt.scrolloff = 9999

vim.opt.hlsearch = false
-- vim.opt.colorcolumn = '80'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.foldlevel = 9999

-- TODO look at 'columns' option

vim.opt.grepprg = "rg -n"

vim.g.mapleader = " "
local map = vim.api.nvim_set_keymap
map('n', '<C-p>', ':Telescope find_files<cr>', {noremap = true})  

-- make all marks global marks (and the same capital and lowercase)
for uppercase_ascii=65,90 do
    char_uppercase = string.char(uppercase_ascii)
    char_lowercase = string.char(uppercase_ascii + 32)
    map('n', 'm' .. char_lowercase, 'm' .. char_uppercase, {noremap = true})
    map('n', '\'' .. char_lowercase, '\'' .. char_uppercase, {noremap = true})
end

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
        { "TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]] };
        { "TermOpen", "*", "startinsert" };
        { "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" };
    };
}

nvim_create_augroups(autocmds)
-- autocommands END
