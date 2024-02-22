return {
  "echasnovski/mini.ai",
  opts = function(_, opts)
    -- opts.respect_selection_type = true
    -- opts.search_method = "next"
    opts.n_lines = 500

    local ai = require("mini.ai")
    opts.custom_textobjects = {
      a = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
      t = ai.gen_spec.treesitter({ a = "@tag.outer", i = "@tag.inner" }, {}),
      A = ai.gen_spec.treesitter({ a = "@parameters.outer", i = "@parameters.inner" }, {}),
    }
    return opts
  end,
}
