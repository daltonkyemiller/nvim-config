return {
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  ---@type TailwindTools.Option
  opts = {

    extension = {
      queries = { "javascript", "jsx", "typescript", "tsx" },
    },
    document_color = {
      enabled = false,
    },
  }, -- your configuration
}
