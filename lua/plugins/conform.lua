--- @type LazySpec
return {
  'stevearc/conform.nvim',
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        javascript = { { 'biome', 'prettierd' } },
        typescript = { { 'biome', 'prettierd' } },
        typescriptreact = { { 'biome', 'prettierd' } },
        javascriptreact = { { 'biome', 'prettierd' } },
        lua = { 'stylua' },
      },
    }
  end,

  keys = function()
    local conform = require 'conform'
    return {
      { '<leader>cf', conform.format, desc = 'LSP: [C]ode [F]ormat' },
    }
  end,
}
