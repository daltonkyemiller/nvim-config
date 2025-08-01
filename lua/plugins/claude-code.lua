--- @type LazySpec
return {
  -- "daltonkyemiller/claude-code.nvim",
  dev = true,
  dir = "~/dev/nvim-plugins/claude-code.nvim",
  build = "cd node && npm install",
  enabled = true,
  ---@type claude-code.Config
  opts = {
    -- debug = true,
    window = {
      position = "float",
      width = 50,
    },
    keymaps = {
      arrow_down = {
        i = "none",
      },
      arrow_up = {
        i = "none",
      },
      arrow_left = {
        i = "none",
      },
      arrow_right = {
        i = "none",
      },
    },
    slash_commands = {
      ["/logout"] = false,
      ["/login"] = false,
      ["/vim"] = false,
      ["/theme"] = false,
    },
    experimental = {
      hide_input_box = true,
    },
  },
  keys = {
    {
      "<leader>cc",
      function()
        require("claude-code.commands").toggle()
      end,
    },
    {
      "<leader>cF",
      function()
        require("claude-code.commands").focus()
      end,
    },
  },
}
