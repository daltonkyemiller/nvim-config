--- @type LazySpec
return {
  "norcalli/nvim-colorizer.lua",
  event = "BufRead",
  opts = {
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
    "html",
    "css",
  },
}
