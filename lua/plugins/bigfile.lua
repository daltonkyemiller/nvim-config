local supermaven = {
  name = "supermaven",
  opts = {
    defer = false,
  },
  disable = function()
    vim.cmd("SupermavenStop")
  end,
}
--- @type LazySpec
return {
  "LunarVim/bigfile.nvim",
  opts = {
    filesize = 1,
    features = {
      "indent_blankline",
      "illuminate",
      "lsp",
      "treesitter",
      "syntax",
      "matchparen",
      "vimopts",
      "filetype",
      supermaven,
    },
  },
}
