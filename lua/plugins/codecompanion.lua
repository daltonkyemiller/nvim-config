--- @type LazySpec
return {
  -- enabled = false,
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.diff",
  },
  opts = {
    display = {
      diff = {
        enabled = true,
        close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
        layout = "vertical", -- vertical|horizontal split for default provider
        opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
        provider = "default", -- default|mini_diff
      },
    },
    strategies = {
      chat = {
        adapter = "anthropic",

        slash_commands = {
          ["file"] = {
            -- Location to the slash command in CodeCompanion
            callback = "strategies.chat.slash_commands.file",
            description = "Select a file using Snacks picker",
            opts = {
              provider = "snacks",
              contains_code = true,
            },
          },
          ["buffer"] = {
            -- Location to the slash command in CodeCompanion
            callback = "strategies.chat.slash_commands.buffer",
            description = "Select a buffer using Snacks picker",
            opts = {
              provider = "snacks",
              contains_code = true,
            },
          },
        },
      },
      inline = {
        adapter = "anthropic",
      },
      cmd = {
        adapter = "anthropic",
      },
    },
  },

  keys = {
    {
      "<leader>cc",
      "<cmd>CodeCompanionChat Toggle<cr>",
      mode = { "n" },
      desc = "Toggle CodeCompanion Chat",
    },
    {
      "<leader>cc",
      "<cmd>'<,'> CodeCompanionChat<cr>",
      mode = { "v" },
      desc = "Toggle CodeCompanion Chat with Visual Selection",
    },
    { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to CodeCompanion Chat" },
  },
  init = function()
    vim.cmd([[cab cc CodeCompanion]])
  end,
}
