-- Miasma color palette
-- Used by lualine and other plugins
-- Theme is defined in lush_theme/miasma.lua

local M = {}

-- Accurate miasma colors from xero/miasma.nvim
M.miasma = {
  palette = {
    -- Backgrounds
    bg = "#222222",
    bg_dark = "#1c1c1c",
    bg_darker = "#111111",
    bg_light = "#333333",

    -- Foregrounds
    fg = "#d7c483",
    fg_dark = "#c2c2b0",

    -- UI
    comment = "#666666",
    selection = "#333333",
    visual = "#78824b",

    -- Accents
    red = "#b36d43",
    orange = "#bb7744",
    yellow = "#c9a554",
    green = "#5f875f",
    olive = "#78824b",
    brown = "#685742",
  },
}

return M
