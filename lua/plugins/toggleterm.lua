--- @type LazySpec
return {
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
