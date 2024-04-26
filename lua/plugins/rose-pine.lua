--- @type LazySpec
return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 150,
  config = function()
    require("rose-pine").setup({
      highlight_groups = {
        ["@type"] = { fg = "gold" },
        ["@keyword.operator"] = { fg = "pine" },

        -- ["@type.builtin"] = { fg = "gold" },
      },
    })
  end,
}
