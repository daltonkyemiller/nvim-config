--- @type LazySpec
return {
  "dnlhc/glance.nvim",
  event = "BufRead",
  config = true,
  opts = {
    list = {
      position = "left",
      width = 30,
    },
  },
  keys = {
    { "gr", "<CMD>Glance references<CR>", desc = "[G]oto [R]eferences" },
  },
}
