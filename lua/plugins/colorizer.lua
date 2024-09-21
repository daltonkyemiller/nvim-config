--- @type LazySpec
return {
  "norcalli/nvim-colorizer.lua",
  event = "BufRead",
  opts = {
    "lua",
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
    "html",
    "css",
    "conf"
  },
}
