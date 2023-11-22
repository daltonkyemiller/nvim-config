return {
  "Wansmer/treesj",
  keys = {
    { "<leader>S", "<cmd>TSJToggle<cr>" },
  },
  config = function()
    require("treesj").setup()
  end,
}
