--- @type LazySpec
return {
  enabled = false,
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    {
      "<leader>t",
      function()
        require("toggleterm").toggle(nil, nil, nil, "float", nil)
      end,
      desc = "Toggle [T]erminal",
    },
  },
  opts = {},
}
