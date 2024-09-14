--- @type LazySpec
return {
  "rcarriga/nvim-notify",
  keys = {
    {
      "<leader>nd",
      function()
        require("notify").dismiss({ all = true })
      end,
      desc = "[N]otify [D]ismiss All",
    },

    {
      "<leader>nb",
      function()
        local notifs = require("notify").history()

        -- example output:
        -- { {
        --     icon = "",
        --     id = 1,
        --     level = "INFO",
        --     message = { "[supermaven-nvim] Supermaven Pro is running." },
        --     render = <function 1>,
        --     time = 1720543566,
        --     title = { "Messages", "11:46:06" }
        --   } }

        vim.cmd("botright new")
        vim.cmd("setlocal buftype=nofile")
        local lines = {}
        for i, notif in ipairs(notifs) do
          lines[i] = string.format("%s %s", notif.icon, notif.message[1])
        end
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      end,
      desc = "[N]otify Open In [B]uffer",
    },
  },
  config = function()
    require("notify").setup({
      max_width = 60,
      top_down = false,
      background_colour = "#000000",
    })
  end,
}
