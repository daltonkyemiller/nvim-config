--- @type LazySpec
return {
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      max_width = 60,
      background_colour = "#000000",
    })
  end,
}
