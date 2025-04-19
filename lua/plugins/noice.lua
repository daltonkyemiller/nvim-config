return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = function()
    local Msg = require("noice.ui.msg")

    return {
      lsp = {
        hover = {
          silent = true,
          ---@type NoiceViewOptions
          opts = {
            border = "rounded",
          },
        },
        override = {
          -- override the default lsp markdown formatter with Noice
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          -- override the lsp markdown formatter with Noice
          ["vim.lsp.util.stylize_markdown"] = true,
          -- override cmp documentation with Noice (needs the other options to work)
          ["cmp.entry.get_documentation"] = true,
        },
      },
      ---@type table<string, NoiceFilter>
      status = {},
    }
  end,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
  },
}
