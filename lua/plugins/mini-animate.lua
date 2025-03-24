--- @type LazySpec
return {
  "echasnovski/mini.animate",
  enabled = false,
  lazy = false,
  config = function()
    local mini_animate = require("mini.animate")
    mini_animate.setup({
      cursor = {
        enable = false,
      },
    scroll = {
      enable = true,
      timing = mini_animate.gen_timing.linear({ duration = 80, unit = "total" }),
      subscroll = mini_animate.gen_subscroll.equal({ max_output_steps = 30 }),
    },
      resize = {
        enable = true,
        timing = mini_animate.gen_timing.linear({ duration = 100, unit = "total" }),
      },
      open = {
        enable = false,
      },
      close = {
        enable = false,
      },
    })
  end,
  --- @type LazyKeysSpec[]
  keys = {
    {
      "<C-u>",
      [[<Cmd>lua vim.cmd('normal! <C-u>'); MiniAnimate.execute_after('scroll', 'normal! zvzz')<CR>]],
      desc = "Move cursor up half page",
      mode = "n",
    },
    {
      "<C-d>",
      [[<Cmd>lua vim.cmd('normal! <C-d>'); MiniAnimate.execute_after('scroll', 'normal! zvzz')<CR>]],
      desc = "Move cursor down half page",
      mode = "n",
    },
  },
}
