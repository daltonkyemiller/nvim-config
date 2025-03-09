--- @type LazySpec
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.diff",
  },
  opts = {
    display = {
      chat = {
        diff = { enabled = true },
      },
      diff = {
        enabled = true,
        provider = "mini_diff",
      },
    },
    strategies = {
      chat = {
        adapter = "anthropic",
      },
      inline = {
        adapter = "anthropic",
      },
      cmd = {
        adapter = "anthropic",
      },
    },
  },

  keys = {
    {
      "<leader>cc",
      "<cmd>CodeCompanionChat Toggle<cr>",
      mode = { "n" },
      desc = "Toggle CodeCompanion Chat",
    },
    {
      "<leader>cc",
      "<cmd>'<,'> CodeCompanionChat<cr>",
      mode = { "v" },
      desc = "Toggle CodeCompanion Chat with Visual Selection",
    },
    { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to CodeCompanion Chat" },
  },
  init = function()
    vim.cmd([[cab cc CodeCompanion]])
  end,
}
