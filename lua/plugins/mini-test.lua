---@module "mini.test"

--- @type LazySpec
return {
  "echasnovski/mini.test",
  opts = {},
  keys = {
    {
      "<leader>t",
      function()
        require("mini.test").run()
      end,
      desc = "Run [T]ests",
    },
  },
}
