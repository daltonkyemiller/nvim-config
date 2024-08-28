--- @type LazySpec
return {
  enabled = false,
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  event = "BufReadPost",
  keys = {
    {
      "<leader>co",
      "<CMD>TSToolsOrganizeImports<CR>",
      desc = "[C]ode [O]rganize Imports",
    },
  },
  opts = {
    settings = {
      expose_as_code_action = {
        "add_missing_imports",
      },
      tsserver_file_preferences = {
        includeInlayParameterNameHints = "all",
      },
    },
  },
}
