--- @type LazySpec
return {
  "numToStr/Comment.nvim",
  dependencies = {
    { "JoosepAlviste/nvim-ts-context-commentstring" },
  },
  opts = function(_, opts)
    opts.pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
    return opts
  end,
  config = true,
}
