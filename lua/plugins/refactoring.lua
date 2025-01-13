--- @type LazySpec
return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    {
      mode = { "n", "x" },
      "<leader>rr",
      function()
        require("refactoring").select_refactor()
      end,
      desc = "[R]efactoring",
    },
    {
      mode = { "n", "x" },
      "<leader>rv",
      function()
        require("refactoring").debug.print_var()
      end,
      desc = "[R]efactoring Print [V]ariable",
    },
  },
  config = function()
    require("refactoring").setup({
      print_var_statements = {
        typescriptreact = {
          "console.log(`%s ${%s}`)"

        }

      }

    })
  end,
}
