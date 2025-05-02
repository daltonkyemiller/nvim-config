return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = function()
    local nonicons = require("nvim-nonicons")

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
      cmdline = {
        format = {
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = {
            kind = "search",
            pattern = "^/",
            icon = nonicons.get("arrow-down") .. " " .. nonicons.get("search"),
            lang = "regex",
          },
          search_up = {
            kind = "search",
            pattern = "^%?",
            icon = nonicons.get("arrow-up") .. " " .. nonicons.get("search"),
            lang = "regex",
          },
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua = {
            pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
            icon = nonicons.get("lua"),
            lang = "lua",
          },
          help = { pattern = "^:%s*he?l?p?%s+", icon = nonicons.get("book-open") },
          input = { view = "cmdline_input", icon = "󰥻 " },
        },
      },
    }
  end,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
  },
}
