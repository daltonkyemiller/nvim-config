--- @type LazySpec
return {
  "echasnovski/mini.base16",
  priority = 1000,
  config = function()
    local palette = require("daltonkyemiller.colors").miasma.palette

    require("mini.base16").setup({
      palette = {
        base00 = palette.bg, -- Default background
        base01 = palette.bg_dark, -- Lighter background (status bars, line numbers)
        base02 = palette.selection, -- Selection background
        base03 = palette.comment, -- Comments, invisibles
        base04 = palette.comment, -- Dark foreground (status bars)
        base05 = palette.fg, -- Default foreground
        base06 = palette.fg, -- Light foreground
        base07 = palette.fg, -- Light background
        base08 = palette.red, -- Variables, errors
        base09 = palette.orange, -- Integers, booleans, constants
        base0A = palette.yellow, -- Classes, search highlight
        base0B = palette.green, -- Strings
        base0C = palette.brown, -- Support, regex
        base0D = palette.olive, -- Functions, methods
        base0E = palette.orange, -- Keywords
        base0F = palette.brown, -- Deprecated, embedded tags
      },
      use_cterm = false,
    })

    vim.g.colors_name = "miasma"
    local groups = {
      "FloatBorder",
      "WinSeparator",
      "SnacksPickerInputBorder",
      "SnacksPickerListBorder",
      "SnacksPickerPreviewBorder",
      "LspFloatWinBorder",
      "DiagnosticFloatingBorder",
      -- "NormalFloat",
    }

    -- for _, group in ipairs(groups) do
    --   vim.api.nvim_set_hl(0, group, { fg = palette.bg, bg = palette.bg })
    -- end

    vim.api.nvim_set_hl(0, "FloatBorder", { fg = palette.border })

    vim.api.nvim_set_hl(0, "SnacksPickerInput", { bg = palette.bg })
    vim.api.nvim_set_hl(0, "SnacksPickerInputBorder", { fg = palette.border })
    vim.api.nvim_set_hl(0, "SnacksPickerListBorder", { fg = palette.border })

    vim.api.nvim_set_hl(0, "SnacksPickerList", { bg = palette.bg })
    vim.api.nvim_set_hl(0, "SnacksPickerPreview", { bg = palette.bg_dark })
    vim.api.nvim_set_hl(0, "SnacksPickerPrompt", { bg = palette.bg })
    vim.api.nvim_set_hl(0, "SnacksPickerTree", { bg = palette.bg, fg = palette.border })
  end,
}
