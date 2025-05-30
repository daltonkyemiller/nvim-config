--- @type  LazySpec
return {
  "chrisgrieser/nvim-spider",
  opts = {},
  keys = {
    { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
  },
}
