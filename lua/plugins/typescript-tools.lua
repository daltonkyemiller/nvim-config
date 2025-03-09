--- @type LazySpec
return {
  "pmizio/typescript-tools.nvim",
  enabled = false,
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
    on_attach = function()
      vim.keymap.set("n", "<leader>co", function()
        vim.cmd("TSToolsOrganizeImports")
      end, { desc = "[C]ode [O]rganize Imports" })

      vim.keymap.set("n", "<leader>cd", function()
        vim.diagnostic.open_float()
      end, { desc = "[C]ode [D]iagnostics" })
    end,
  },
}
