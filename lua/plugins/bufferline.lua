return {
  "akinsho/bufferline.nvim",
  keys = {
    {
      "<leader>bb",
      function()
        require("bufferline").pick()
      end,
      desc = "Pick buffer",
    },
  },
}
