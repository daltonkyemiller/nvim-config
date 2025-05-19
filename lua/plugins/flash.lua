---@type LazySpec
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    autohide = true,
    ---@type table<string, Flash.Config>
    modes = {
      search = {
        enabled = true,
        incremental = true,
        exclude = {
          "blink-cmp-menu",
        },
      },
    },
  },
  keys = {
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "[R]emote Flash",
    },
  },
}
