--- @type LazySpec
return {
  enabled = false,
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 150,
  config = function()
    require("rose-pine").setup({
      variant = "moon",
      styles = {
        -- italic = false,
        transparency = true,
      },
      palette = {
        moon = {
          base = "#1D2021",
          surface = "#1D2021",
          overlay = "#2A2F30",
        },
      },
      highlight_groups = {
        ["@type"] = { fg = "gold" },
        ["@keyword.operator"] = { fg = "pine" },

        TelescopeNormal = { bg = "base" },
        TelescopeBorder = { bg = "base", fg = "foam" },
        TelescopeTitle = { fg = "foam", bg = "base" },
        TelescopePromptNormal = { bg = "base" },
        NeoTreeFloatBorder = { bg = "base", fg = "foam" },
        NeoTreeTitleBar = { fg = "base", bg = "foam" },
        TelescopePromptPrefix = { bg = "surface", fg = "foam" },
        TelescopePromptCounter = { fg = "foam" },
        -- NoiceCmdlinePopupBorder = { bg = "base", fg = "foam" },
        -- NoiceCmdlineIcon = { fg = "foam" },
        -- NoiceCmdline = { bg = "base", fg = "foam" },
        -- Title = { fg = "foam", bg = "base" },
        -- NoiceCompletionItemWord = { fg = "love" },

        -- Prompt
        -- TelescopePromptNormal = { bg = "surface" },
        -- TelescopePromptBorder = { bg = "base", fg = "love" },
        -- TelescopePromptTitle = { fg = "love", bg = "surface" },

        -- Results
        -- TelescopeResultsNormal = { bg = "surface" },
        -- TelescopeResultsBorder = { bg = "base", fg = "love" },
        -- TelescopeResultsTitle = { fg = "love", bg = "base" },
        -- TelescopeSelection = { bg = "surface" },

        -- Preview
        -- TelescopePreviewNormal = { bg = "base" },
        -- TelescopePreviewBorder = { bg = "base", fg = "love" },
        -- TelescopePreviewTitle = { fg = "love", bg = "base" },

        -- ["@type.builtin"] = { fg = "gold" },
      },
    })
  end,
}
