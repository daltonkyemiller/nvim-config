return {
  "folke/flash.nvim",
  enabled = false,
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        -- default options: exact mode, multi window, all directions, with a backdrop
        require("flash").jump()
      end,
      desc = "Flash",
    },
    { "S", false },
    -- {
    --   "S",
    --   mode = { "n" },
    --   function()
    --     require("flash").treesitter()
    --   end,
    --   desc = "Flash Treesitter",
    -- },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
  },
}
