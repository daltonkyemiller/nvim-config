---@type LazySpec
return {
  "smjonas/live-command.nvim",
  config = function()
    require("live-command").setup({
      Norm = { cmd = "norm" },
    })
  end,
}
