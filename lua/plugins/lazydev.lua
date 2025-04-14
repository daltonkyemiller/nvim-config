--- @type LazySpec
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      "~/dev/nvim-plugins/claude-code.nvim",
      "~/.config/nvim/lua/daltonkyemiller/globals",
      "lazy.nvim",
      "flash.nvim",
      "mini.test",
      "nvim-treesitter.configs",
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
