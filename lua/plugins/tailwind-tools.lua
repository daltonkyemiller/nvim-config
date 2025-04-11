return {
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  ---@type TailwindTools.Option
  opts = {
    document_color = {
      enabled = false,
    },
  }, -- your configuration
}
