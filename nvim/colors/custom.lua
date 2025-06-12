-- helpers for generating colors
-- TODO inline generated colors and keep these functions for experimenting
local color_mix
do
    local color_to_color_table = function(color_string)
        return {
            red = tonumber(string.sub(color_string, 2, 3), 16),
            green = tonumber(string.sub(color_string, 4, 5), 16),
            blue = tonumber(string.sub(color_string, 6, 7), 16),
        }
    end

    local color_table_sum = function(color_1, color_2)
        return {
            red = color_1.red + color_2.red,
            green = color_1.green + color_2.green,
            blue = color_1.blue + color_2.blue,
        }
    end

    local color_table_product = function(color, scalar)
        return {
            red = color.red * scalar,
            green = color.green * scalar,
            blue = color.blue * scalar,
        }
    end

    local color_table_mix = function(top, bottom, top_opacity)
        assert(top_opacity <= 1)
        assert(top_opacity >= 0)
        return color_table_sum(
            color_table_product(top, top_opacity),
            color_table_product(bottom, 1 - top_opacity))
    end

    local color_table_to_color = function(color)
        return "#" .. string.format("%02x", color.red)
            .. string.format("%02x", color.green)
            .. string.format("%02x", color.blue)
    end

    color_mix = function(top, bottom, top_opacity)
        return color_table_to_color(
            color_table_mix(color_to_color_table(top),
            color_to_color_table(bottom), top_opacity)
        )
    end
end

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
local flamingo = "#f2cdcd"

local background = "#1e1e2e" -- Base
local secondary_background = "#181825" -- Mantle
local subtle = "#45475a" -- Surface 1

local mixed_yellow = color_mix(yellow, background, 0.15)

 -- the the following sets to highlights rely on defaults so reset them first
vim.cmd.highlight("clear")

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
    ["Directory"] = { fg = blue },
    ["Normal"] = { fg = white, bg = background },
    ["LineNr"] = { fg = subtle },
    ["NormalFloat"] = { bg = secondary_background },
    ["Visual"] = { bg = subtle, bold = true },
    ["EndOfBuffer"] = { fg = background }, -- to make this hidden

    ["DiffDelete"] = { bg = color_mix(red, background, 0.15) },
    ["DiffChange"] = { bg = mixed_yellow },
    ["DiffAdd"] = { bg = color_mix(green, background, 0.15) },
    ["DiffText"] = { bg = mixed_yellow, bold = true },

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

    ["@keyword.modifier"] = { link = "@type" },
    ["@keyword.operator"] = { link = "@operator" },
    -- make c and cpp includes PreProc because they are
    ["@keyword.import.c"] = { link = "PreProc" },
    ["@keyword.import.cpp"] = { link = "PreProc" },
    ["@keyword.operator"] = { link = "@operator" },
    ["@keyword.conditional.ternary"] = { link = "@operator" },
    ["@keyword.directive"] = { link = "PreProc" },

    -- lsp
    ["@lsp.type.interface"] = { fg = flamingo },
    ["@lsp.type.macro"] = { link = "Macro" },

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

    -- telescope
    ["TelescopeBorder"] = { fg = blue },
}
for highlight_group, definition in pairs(highlights) do
    vim.api.nvim_set_hl(0, highlight_group, definition)
end

vim.g.colors_name = "custom"
