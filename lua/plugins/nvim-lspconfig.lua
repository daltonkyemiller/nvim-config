return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
    },
    setup = {
      tsserver = function(_, opts)
        require("typescript").setup({ server = opts })

        -- local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- require("lspconfig").tsserver.setup({
        --   capabilities = capabilities,
        -- })

        return true
      end,
    },
  },
}
