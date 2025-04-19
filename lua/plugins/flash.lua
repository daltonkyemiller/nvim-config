---@type LazySpec
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    ---@type table<string, Flash.Config>
    modes = {
      search = { enabled = true },
    },
  },
}
