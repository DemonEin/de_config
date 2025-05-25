-- colors from catpuccin mocha
-- trailing comments give the color's name in catpuccin if different than
-- the variable name
local white = "#cdd6f4" -- Text
local red = "#f38ba8"
local purple = "#cba6f7" -- Mauve
local green = "#a6e3a1"
local orange = "#fab387" -- Peach
local blue = "#89b4fa"
local cyan = "#89dceb" -- Sky
local lavender = "#b4befe"
local yellow = "#f9e2af"
local pink = "#f5c2e7"

local background = "#1e1e2e" -- Base
local secondary_background = "#181825" -- Mantle


local highlights = {
    ["ErrorMsg"] = { link = "DiagnosticError" },
    ["ModeMsg"] = { link = "Normal" },
    ["MoreMsg"] = { link = "Normal" },
    ["Question"] = { link = "Normal" },
    ["QuickFixLine"] = { link = "Normal" },
    ["StatusLineNC"] = { link = "StatusLine" },
    ["CurSearch"] = { link = "Visual" },
    ["Search"] = { link = "Visual" },

    ["Title"] = { bold = true },
    ["SpecialKey"] = { fg = pink },
    ["Directory"] = { fg = cyan },
    ["Normal"] = { fg = white, bg = background },
    ["LineNr"] = { fg = "#45475a" }, -- Surface 1

    -- vim syntax
    ["Comment"] = { fg = "#9399b2", italic = false },

    ["Constant"] = { fg = orange },
    ["String"] = { fg = green },

    ["Identifier"] = { link = "Normal" },
    ["Function"] = { fg = yellow },

    ["Conditional"] = { link = "Keyword" },
    ["Conditional"] = { link = "Keyword" },
    ["Repeat"] = { link = "Keyword" },
    ["Label"] = { link = "Keyword" },
    ["Operator"] = { fg = cyan },
    ["Keyword"] = { fg = purple },
    ["Exception"] = { link = "Keyword" },

    ["PreProc"] = { fg = pink },

    ["Type"] = { fg = blue },

    ["Special"] = {},
    ["Delimiter"] = { fg = "#9399b2" }, -- Overlay 2

    ["Error"] = { link = "DiagnosticError" },

    ["Todo"] = { bold = true },

    ["Added"] = { fg = green },
    ["Changed"] = { fg = yellow },
    ["Removed"] = { fg = red },

    -- treesitter
    ["@variable"] = { link = "Identifier" },
    ["@variable.builtin"] = { link = "@variable" },
    ["@variable.parameter.builtin"] = { link = "@variable.parameter" },
    ["@variable.member"] = { fg = lavender },

    ["@constant.builtin"] = { link = "@constant" },

    ["@module"] = { fg = lavender },
    ["@module.builtin"] = { link = "@module" },

    ["@type.builtin"] = { link = "@type" },

    ["@attribute.builtin"] = { link = "@attribute" },
    ["@property"] = { link = "@variable.member" },

    ["@function.builtin"] = { link = "@function" },
    ["@constructor"] = {},

    -- lsp
    ["@lsp.type.macro"] = { link = "Macro" },
    ["@lsp.mod.readonly"] = { link = "Constant" },

    -- diagnostics
    ["DiagnosticError"] = { fg = red },
    ["DiagnosticWarn"] = { fg = yellow },
    ["DiagnosticInfo"] = { fg = cyan },
    ["DiagnosticHint"] = { fg = cyan },

    ["SpellBad"] = { sp = red, undercurl = true },
    ["SpellCap"] = { sp = yellow, undercurl = true },
    ["SpellLocal"] = { sp = cyan, undercurl = true },
    ["SpellRare"] = { sp = cyan, undercurl = true },

    ["StatusLine"] = { bg = secondary_background },
    ["Folded"] = { bg = secondary_background },
}
for highlight_group, definition in pairs(highlights) do
    vim.api.nvim_set_hl(0, highlight_group, definition)
end
