return {
  "echasnovski/mini.ai",
  opts = function(_, opts)
    local ai = require("mini.ai")
    opts.custom_textobjects.a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }, {})
    return opts
  end,
}
