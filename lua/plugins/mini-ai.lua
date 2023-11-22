return {
  "echasnovski/mini.ai",
  opts = function(_, opts)
    -- opts.respect_selection_type = true
    -- opts.search_method = "next"
    opts.n_lines = 500

    local ai = require("mini.ai")
    opts.custom_textobjects.a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }, {})
    opts.custom_textobjects.t = ai.gen_spec.treesitter({ a = "@tag.outer", i = "@tag.inner" }, {})
    opts.custom_textobjects.A = ai.gen_spec.treesitter({ a = "@parameters.outer", i = "@parameters.inner" }, {})
    -- opts.custom_textobjects.t = false
    return opts
  end,
}
