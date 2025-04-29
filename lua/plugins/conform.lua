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
      json = { "prettierd" },
      jsonc = { "prettierd" },
      typescriptreact = get_correct_formatter_js,
      javascriptreact = get_correct_formatter_js,
      prisma = { "prettierd" },
      lua = { "stylua" },
      starlark = { "black" },
      sql = { "pg_format" },
      html = { "prettierd" },
      css = { "prettierd" },
      markdown = { "prettierd" },
      glsl = { "clang_format" },
      reason = { "reason_fmt" },
      rust = { "rustfmt" },
      toml = { "taplo" },
      yaml = { "prettierd" },
      ["*"] = { "injected" },
    },

    formatters = {
      reason_fmt = function()
        return {
          command = "refmt",
        }
      end,
    },
  },
  config = true,

  ---@diagnostic disable-next-line: assign-type-mismatch
  keys = function()
    local conform = require("conform")
    return {
      {
        "<leader>cf",
        function()
          if require("daltonkyemiller.util").is_specific_lsp_attached_to_buffer("tailwindcss") then
            vim.cmd("TailwindSort")
          end

          conform.format()
        end,
        desc = "LSP: [C]ode [F]ormat",
      },
    }
  end,
}
