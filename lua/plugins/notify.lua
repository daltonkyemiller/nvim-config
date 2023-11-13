-- These messages are ignored by notify, because they are annoying
-- local ignored_msgs = {"workspace/executeCommand"}

-- local notify = require("notify")

return {
  'rcarriga/nvim-notify',
  opts = function(_, opts)
    opts.background_colour = "#000"

    return opts
  end,
  -- config = function()
  --   notify.background_colour = "#000"
  --
  --   vim.notify = function (msg, ...)
  --     for i, ignored in ipairs(ignored_msgs) do
  --      if(string.match(msg, ignored)) then
  --        return
  --      end
  --     end
  --     notify(msg, ...)
  --   end
  -- end
}
