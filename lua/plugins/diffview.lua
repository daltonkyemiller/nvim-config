--- @type LazySpec
return {
  "dlyongemallo/diffview.nvim",
  opts = {},

  keys = {
    {
      mode = { "n" },
      "<leader>gd",
      function()
        require("diffview").toggle({})
      end,
      desc = "[G]it [D]iffview",
    },

    {
      mode = { "n" },
      "<leader>gD",
      function()
        require("diffview").file_history(nil, { "%" })
      end,
      desc = "[G]it [D]iffview",
    },
  },
}
