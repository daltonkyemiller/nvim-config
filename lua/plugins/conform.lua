local function get_correct_formatter_js()
  local cwd = vim.fn.getcwd()
  local has_biome_file = vim.fn.filereadable(cwd .. "/biome.json") == 1
  return has_biome_file and { "biome" } or { "prettierd" }
end

--- @type LazySpec
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      astro = { "prettierd" },
      javascript = get_correct_formatter_js,
      typescript = get_correct_formatter_js,
      json = get_correct_formatter_js,
      typescriptreact = get_correct_formatter_js,
      javascriptreact = get_correct_formatter_js,
      prisma = { "prettierd" },
      lua = { "stylua" },
      starlark = { "black" },
      sql = { "pg_format" },
      html = { "prettierd" },
      css = { "prettierd" },
      glsl = { "clang_format" },
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
