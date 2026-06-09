--- @type LazySpec
return {
  dev = true,
  dir = "~/dev/switchboard/nvim/",
  lazy = false,
  --- @type SwitchboardConfig
  opts = {
    command = "/home/dalton/dev/switchboard/cli/dist/debug/switchboard",
  },
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
