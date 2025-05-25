require("config.lazy")
vim.api.nvim_create_autocmd("VimEnter", { callback = function()
    if require("lazy.status").has_updates then
        require("lazy").update({ show = false })
    end
end })

vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

require("telescope").load_extension("fzf")
require("oil").setup({
    keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        -- these are defaults I disabled; leaving commented to consider
        -- later
        -- ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        -- ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        -- ["<C-t>"] = { "actions.select", opts = { tab = true } },
        -- ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-l>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
    use_default_keymaps = false,
    view_options = {
        show_hidden = true,
    },
})

local gitsigns = require("gitsigns")
gitsigns.setup({
    signcolumn = false,
    numhl = true,

    -- copied from gitsigns readme
    on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Actions
        map("v", "<Leader>hs", function()
            gitsigns.stage_hunk { vim.fn.line("."), vim.fn.line("v") }
        end)
        map("v", "<Leader>hr", function()
            gitsigns.reset_hunk { vim.fn.line("."), vim.fn.line("v") }
        end)

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end
})

require("lsp-config")

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "c",
        "cpp",
        "bash",
        "make",
        "rust",
        "verilog",
        "python",
        "lua",
        "vimdoc",
        "markdown",
    },
    highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
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
        brs = 'brightscript',
    }
})

require("lualine").setup({
    sections = {
        lualine_a = { function()
            return string.gsub(vim.fn.getcwd(), "^" .. vim.fn.getenv("HOME"), "~")
        end },
        lualine_b = {"branch"},
        lualine_c = {"filename"},
        lualine_x = {},
        lualine_y = {"progress"},
        lualine_z = {"location"},
    },
})

vim.cmd.colorscheme("custom")

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

vim.cmd("set clipboard+=unnamedplus")

-- options
vim.o.autowrite = true
vim.o.autowriteall = true
vim.o.cmdheight = 0 -- if removing, search for 'cmdheight' to see things that relate
                    -- and might have to be changed
-- vim.o.colorcolumn = '80'
vim.o.expandtab = true
vim.o.fillchars = "diff: "
vim.o.foldlevel = 9999
vim.o.hlsearch = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 9999 -- keep cursor vertically centered
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.spelllang = "en_us"
vim.o.splitright = true
vim.o.tabstop = 4
vim.o.tildeop = true
vim.o.updatetime = 100
vim.o.wrap = false

vim.diagnostic.config({
    virtual_text = {
        severity = { min = vim.diagnostic.severity.INFO },
    },
    signs = false,
})

local telescope_actions = require("telescope.actions")
local telescope_action_state = require("telescope.actions.state")

local telescope_pickers = require("telescope.pickers")
local telescope_finders = require("telescope.finders")
local telescope_config = require("telescope.config").values
local telescope_builtin = require("telescope.builtin")

-- keymaps, sorted by their position on the keyboard, first by row then by column

-- I don't generally add keymaps in on_attach functions because I don't like to
-- use keys for other things when the plugin/lsp/whatever isn't attached

vim.g.mapleader = " "

-- normal mode keymaps
for _, map in ipairs({
    { "gr", vim.lsp.buf.references },
    { "gi", vim.lsp.buf.implementation },
    { "gd", vim.lsp.buf.definition },
    { "gD", vim.lsp.buf.declaration },
    { "K", vim.lsp.buf.hover },
    { "[d", vim.diagnostic.goto_prev },
    { "]d", vim.diagnostic.goto_next },

    { "<C-p>", telescope_builtin.find_files },
    { "<C-j>", "<C-w>j" },
    { "<C-l>", "<C-w>l" },
    { "<C-t>", function(opts) -- telescope picker to change directory
        opts = opts or {}
        local home_directory = os.getenv("HOME")
        telescope_pickers.new(opts, {
            prompt_title = "Change Directory",
            finder = telescope_finders.new_oneshot_job({
                "find",
                home_directory,
                "-maxdepth",
                "1", "-mindepth",
                "1", "-type", "d",
                "-printf",
                "%f\\n",
            }, {}),
            sorter = telescope_config.file_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                telescope_actions.select_default:replace(function()
                    telescope_actions.close(prompt_bufnr)
                    vim.cmd("cd "
                        .. home_directory
                        .. "/"
                        .. telescope_action_state.get_selected_entry()[1]
                    )
                    telescope_builtin.find_files()
                end)
                return true
            end,
        }):find()
    end },
    { "<C-n>", ":silent cn<cr>" },
    { "<C-e>", ":silent cp<cr>" },
    { "<C-c>", function() 
        vim.o.termguicolors = not vim.o.termguicolors
        if vim.o.termguicolors then
            print("enabled terminal gui colors")
        else
            print("disabled terminal gui colors")
        end
    end },
    { "<C-k>", "<C-w>k" },
    { "<C-h>", "<C-w>h" },
    { "<C-.>", function()
        if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
        else
            gitsigns.nav_hunk("next")
        end
    end },
    { "<C-/>", function()
        if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
        else
            gitsigns.nav_hunk("prev")
        end
    end },

    { "<Leader>q", vim.diagnostic.setloclist },
    { "<Leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end },
    { "<Leader>wa", vim.lsp.buf.add_workspace_folder },
    { "<Leader>wr", vim.lsp.buf.remove_workspace_folder },
    { "<Leader>f", vim.lsp.buf.format },
    { "<Leader>b", ":Git blame<cr>" },
    { "<Leader>j", "!$jq<cr>" },
    { "<Leader>r", ":grep '\\b(<C-r><C-w>)\\b'<cr>" },
    { "<Leader>s", ":wa<cr>:sus<cr>" },
    { "<Leader>t", function() -- run t.sh
        terminal_command = "te de; shopt -s expand_aliases; . t.sh"

        vim.cmd("wa")

        tsh_window_number = vim.fn.bufwinnr("t.sh")
        if tsh_window_number ~= -1 then
            vim.cmd("norm " .. tsh_window_number .. " <C-W><C-W>")
            vim.cmd(terminal_command)
        else
            vim.cmd("vs +" .. string.gsub(terminal_command, " ", "\\ "))
        end
    end },
    { "<Leader>g", ":Git " },
    { "<Leader>n", ":vs t.sh<cr>" },
    { "<Leader>e", vim.diagnostic.open_float },
    { "<Leader>i", ":grep -i '\\b(<C-r><C-w>)\\b'<cr>" },
    { "<Leader>z", function() -- quit unless last window
        if (#vim.api.nvim_tabpage_list_wins(0)) > 1 then
            vim.cmd("q")
        end
    end },
    { "<Leader>ca", vim.lsp.buf.code_action },
    { "<Leader>D", vim.lsp.buf.type_definition },
    { "<Leader>v", function() require("gitsigns").toggle_deleted() end },
    { "<Leader>h", ":vert h " },
    { "<Leader>hp", gitsigns.preview_hunk },
    { "<Leader>hb", function() gitsigns.blame_line({ full = true }) end },
    { "<Leader>hu", gitsigns.undo_stage_hunk },
    { "<Leader>hr", gitsigns.reset_hunk },
    { "<Leader>hR", gitsigns.reset_buffer },
    { "<Leader>hs", gitsigns.stage_hunk },
    { "<Leader>hS", gitsigns.stage_buffer },
    { "<Leader>hd", gitsigns.diffthis },
    { "<Leader>hD", function() gitsigns.diffthis("~") end },
    { "<Leader>.", function()
        vim.cmd.wa()
        vim.cmd.source(vim.fn.stdpath("config") .. "/init.lua")
    end },
}) do
    vim.keymap.set("n", map[1], map[2])
end

vim.keymap.set("ca", "H", "vert h")

-- make all marks global marks (and the same capital and lowercase)
for uppercase_ascii=65,90 do
    char_uppercase = string.char(uppercase_ascii)
    char_lowercase = string.char(uppercase_ascii + 32)
    vim.keymap.set("n", "m" .. char_lowercase, "m" .. char_uppercase)
    vim.keymap.set("n", "'" .. char_lowercase, "'" .. char_uppercase)
end

for _, autocommand in ipairs({
    { "TermOpen", "*", function()
        vim.keymap.set("t", "<Esc>", "<c-\\><c-n>", { buffer = true })
        vim.wo.listchars = ""
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.cmd.startinsert()
    end },

    { "FileType", "gitcommit,text,markdown", function() vim.o.spell = true end },

    { "RecordingEnter", "*", function() vim.o.cmdheight = 1 end },
    { "RecordingLeave", "*", function() vim.o.cmdheight = 0 end },

    { "FocusLost", "*", function() vim.cmd.wa() end },
    { "VimSuspend", "*", function() vim.cmd.wa() end },
}) do
    vim.api.nvim_create_autocmd(autocommand[1], {
        pattern = autocommand[2],
        callback = autocommand[3],
    })
end
