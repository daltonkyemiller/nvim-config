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
      python = { "isort", "black" },
      typescriptreact = get_correct_formatter_js,
      javascriptreact = get_correct_formatter_js,
      prisma = { "prettierd" },
      lua = { "stylua" },
      starlark = { "black" },
      sql = { "pg_format" },
      html = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      markdown = { "prettierd" },
      glsl = { "clang_format" },
      reason = { "reason_fmt" },
      rust = { "rustfmt" },
      toml = { "taplo" },
      yaml = { "prettierd" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      go = { "gofmt" },
      qml = { "qml_fmt" },
      jinja = { "djlint" },
      ["*"] = { "injected" },
    },

    formatters = {
      qml_fmt = function()
        return {
          command = "/usr/lib/qt6/bin/qmlformat",
          args = { "$FILENAME" },
        }
      end,
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

          vim.cmd("w!")

          conform.format()
        end,
        desc = "LSP: [C]ode [F]ormat",
      },
    }
  end,
}
