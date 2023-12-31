return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping["<C-j>"] = cmp.mapping.select_next_item()
      opts.mapping["<C-k>"] = cmp.mapping.select_prev_item()

      opts.mapping["<A-Space>"] = cmp.mapping({
        i = function()
          if cmp.visible() then
            cmp.close()
          else
            cmp.complete()
          end
        end,
      })
    end,
  },
}
