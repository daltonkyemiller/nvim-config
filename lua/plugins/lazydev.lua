--- @type LazySpec
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      "~/dev/nvim-plugins/claude-code.nvim",
      "~/dev/nvim-plugins/claude-code.nvim/.tests/data/nvim/lazy/nvim-cmp",
      "~/.config/nvim/lua/daltonkyemiller/globals",
      "kanagawa.nvim",
      "lazy.nvim",
      "flash.nvim",
      "mini.test",
      "noice.nvim",
      "nvim-treesitter.configs",
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
