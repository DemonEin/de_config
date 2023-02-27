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

-- define this in WSL so clipboard is set correcty
-- needed to fix startup performance issue
if os.getenv("IS_WSL") then
    -- taken from mzr1996's comment on https://github.com/neovim/neovim/issues/9570
    vim.cmd [[
      let g:clipboard = {
      \ 'name': 'win32yank',
      \ 'copy': {
      \    '+': 'win32yank.exe -i --crlf',
      \    '*': 'win32yank.exe -i --crlf',
      \  },
      \ 'paste': {
      \    '+': 'win32yank.exe -o --lf',
      \    '*': 'win32yank.exe -o --lf',
      \ },
      \ 'cache_enabled': 0,
      \ }
    ]]
end

vim.cmd('set clipboard+=unnamedplus')

-- keep cursor centered 
vim.opt.scrolloff = 9999

vim.opt.cmdheight = 0

vim.opt.hlsearch = false
-- vim.opt.colorcolumn = '80'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.foldlevel = 9999

vim.opt.updatetime = 100

-- TODO look at 'columns' option

vim.opt.grepprg = "rg -n"

vim.g.mapleader = " "
local map = vim.api.nvim_set_keymap
map('n', '<C-p>', ':Telescope find_files<cr>', {noremap = true})  
map('n', '<Leader>s', ':grep <C-r><C-w><cr>', {noremap = true})
map('n', '<Leader>i', ':grep -i <C-r><C-w><cr>', {noremap = true})
map('n', '<C-n>', ':cn<cr>', {noremap = true})
map('n', '<C-e>', ':cp<cr>', {noremap = true})
map('n', '<Leader>g', ':te git ', {noremap = true})

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
