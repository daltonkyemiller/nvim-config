--- @type LazySpec
return {
  enabled = false,
  "ninetyfive-gg/ninetyfive.nvim",

  opts = {
    mappings = {
      enabled = true,
      accept = "<Tab>",
      reject = "<S-Tab>",
      -- accept_word = "<C-j>",
    },
  },
}
