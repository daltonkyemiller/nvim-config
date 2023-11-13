local get_root_dir = function(fname)
  local util = require("lspconfig.util")
  return util.root_pattern(".git")(fname) or util.root_pattern("package.json", "tsconfig.json")(fname)
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "jose-elias-alvarez/typescript.nvim",
        init = function()
          require("typescript").setup({})
          require("lazyvim.util").lsp.on_attach(function(_, buffer)
            vim.keymap.set("n", "<leader>co", function()
              vim.lsp.buf.execute_command({
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
              })
            end, { buffer = buffer, desc = "Organize Imports" })
            vim.keymap.set(
              "n",
              "<leader>cR",
              "<Cmd>TypescriptRenameFile<CR>",
              { desc = "Rename File", buffer = buffer }
            )
          end)
        end,
      },
    },
    opts = {
      servers = {
        tsserver = {
          root_dir = get_root_dir,
        },
      },
    },
  },
}
