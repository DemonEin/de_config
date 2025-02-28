require("config.lazy")
vim.api.nvim_create_autocmd("VimEnter", {callback = function()
    if require("lazy.status").has_updates then
        require("lazy").update({show = false})
    end
end})

vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

require("catppuccin").setup({
    custom_highlights = function(colors)
        return {
            Type = { fg = colors.blue },
            Function = { fg = colors.yellow },
            Character = { fg = colors.teal },
        }
    end,

    styles = {
        conditionals = {},
    },
})

require('telescope').load_extension('fzf')

require('gitsigns').setup{
    signcolumn = false,
    numhl = true,

    -- copied from gitsigns readme
    on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({']c', bang = true})
          else
            gitsigns.nav_hunk('next')
          end
        end)

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({'[c', bang = true})
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)
        map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('n', '<leader>hS', gitsigns.stage_buffer)
        map('n', '<leader>hu', gitsigns.undo_stage_hunk)
        map('n', '<leader>hR', gitsigns.reset_buffer)
        map('n', '<leader>hp', gitsigns.preview_hunk)
        map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
        map('n', '<leader>hd', gitsigns.diffthis)
        map('n', '<leader>hD', function() gitsigns.diffthis('~') end)

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end
}

require('lsp-config')

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.brightscript = {
  install_info = {
    url = "~/tree-sitter-brightscript", -- local path or git repo
    files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
    -- optional entries:
    branch = "main", -- default branch in case of git repo if different from master
    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  },
}

vim.filetype.add({
    extension = {
        brs = 'brightscript'
    }
})

vim.cmd [[colorscheme catppuccin]]
vim.opt.relativenumber = true
vim.opt.number = true

link_highlights = {
    ['@function.builtin'] = '@function',
    ['@variable.builtin'] = '@variable',
    ['@parameter'] = '@variable',
    ['@type.builtin'] = '@type',
    ['StorageClass'] = 'Type',
    ['Structure'] = 'Type',
}

for source, target in pairs(link_highlights) do
    vim.api.nvim_set_hl(0, source, { link = target } )
end

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

vim.opt.wrap = false

-- if removing, search for 'cmdheight' to see things that relate
-- and might have to be changed
vim.opt.cmdheight = 0

vim.opt.hlsearch = false
-- vim.opt.colorcolumn = '80'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.foldlevel = 9999

vim.opt.updatetime = 100

vim.o.splitright = true

-- TODO look at 'columns' option

vim.opt.fillchars = "diff: "
vim.o.list = true
vim.o.listchars = "trail:_"

vim.o.tildeop = true

vim.diagnostic.config({
    virtual_text = {
        severity = { min = vim.diagnostic.severity.INFO },
    },
    signs = false,
})

vim.g.mapleader = " "
vim.keymap.set('n', '<C-p>', ':Telescope find_files<cr>')
vim.keymap.set('n', '<Leader>r', ':grep \'\\b(<C-r><C-w>)\\b\'<cr>')
vim.keymap.set('n', '<Leader>s', ':wa<cr>:sus<cr>')
vim.keymap.set('n', '<Leader>i', ':grep -i \'\\b(<C-r><C-w>)\\b\'<cr>')
vim.keymap.set('n', '<C-n>', ':silent cn<cr>')
vim.keymap.set('n', '<C-e>', ':silent cp<cr>')
vim.keymap.set('n', '<Leader>g', ':Git ')
vim.keymap.set('n', '<Leader>b', ':Git blame<cr>')
vim.keymap.set('n', '<Leader>h', ':vert h ')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<Leader>v', function()
    require('gitsigns').toggle_deleted()
end)

function quit_unless_last_window()
    if (#vim.api.nvim_tabpage_list_wins(0)) > 1 then
        vim.cmd('q')
    end
end

vim.keymap.set('n', '<Leader>z', quit_unless_last_window)

vim.keymap.set('n', '<Leader>j', '!$jq<cr>')

function run_tsh()
    terminal_command = 'te de; shopt -s expand_aliases; . t.sh'

    vim.cmd('wa')

    tsh_window_number = vim.fn.bufwinnr('t.sh')
    if tsh_window_number ~= -1 then
        vim.cmd('norm ' .. tsh_window_number .. ' <C-W><C-W>')
        vim.cmd(terminal_command)
    else
        vim.cmd('vs +' .. string.gsub(terminal_command, ' ', '\\ '))
    end
end

vim.keymap.set('n', '<Leader>t', run_tsh)
vim.keymap.set('n', '<Leader>n', ':vs t.sh<cr>')

vim.keymap.set('ca', 'H', 'vert h')

-- make all marks global marks (and the same capital and lowercase)
for uppercase_ascii=65,90 do
    char_uppercase = string.char(uppercase_ascii)
    char_lowercase = string.char(uppercase_ascii + 32)
    vim.keymap.set('n', 'm' .. char_lowercase, 'm' .. char_uppercase)
    vim.keymap.set('n', '\'' .. char_lowercase, '\'' .. char_uppercase)
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
    list_chars = {
        { "InsertEnter", "*", "setlocal nolist" };
        { "InsertLeave", "*", "setlocal list" };
    };
}

nvim_create_augroups(autocmds)
-- autocommands END
