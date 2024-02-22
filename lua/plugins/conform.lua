--- @type LazySpec
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { { "biome", "prettierd" } },
      typescript = { { "biome", "prettierd" } },
      json = { { "biome", "prettierd" } },
      typescriptreact = { { "biome", "prettierd" } },
      javascriptreact = { { "biome", "prettierd" } },
      prisma = { "prettierd" },
      lua = { "stylua" },
      starlark = { "black" },
    },
  },
  config = true,

  ---@diagnostic disable-next-line: assign-type-mismatch
  keys = function()
    local conform = require("conform")
    return {
      { "<leader>cf", conform.format, desc = "LSP: [C]ode [F]ormat" },
    }
  end,
}
