--- @type LazySpec
return {
  dev = true,
  dir = "~/dev/switchboard/nvim/",
  lazy = false,
  keys = {
    {
      "<M-s>",
      mode = { "x" },
      function()
        require("switchboard.commands").send_selection_reference({
          focus = true,
        })
      end,
    },
  },
}
