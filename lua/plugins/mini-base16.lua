--- @type LazySpec
return {
  "echasnovski/mini.base16",
  priority = 1000,
  config = function()
    local palette = require("daltonkyemiller.colors").miasma.palette

    require("mini.base16").setup({
      palette = {
        base00 = palette.bg,        -- Default background
        base01 = palette.bg_dark,   -- Lighter background (status bars, line numbers)
        base02 = palette.selection, -- Selection background
        base03 = palette.comment,   -- Comments, invisibles
        base04 = palette.comment,   -- Dark foreground (status bars)
        base05 = palette.fg,        -- Default foreground
        base06 = palette.fg,        -- Light foreground
        base07 = palette.fg,        -- Light background
        base08 = palette.red,       -- Variables, errors
        base09 = palette.orange,    -- Integers, booleans, constants
        base0A = palette.yellow,    -- Classes, search highlight
        base0B = palette.green,     -- Strings
        base0C = palette.brown,     -- Support, regex
        base0D = palette.olive,     -- Functions, methods
        base0E = palette.orange,    -- Keywords
        base0F = palette.brown,     -- Deprecated, embedded tags
      },
      use_cterm = false,
    })

    vim.g.colors_name = "miasma"

    -- Subtle window separators
    -- vim.api.nvim_set_hl(0, "WinSeparator", { fg = palette.bg_dark, bg = "NONE"})
  end,
}
