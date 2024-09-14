local create_daily_note = require("daltonkyemiller.daily_note").create_daily_note

vim.api.nvim_create_user_command("DailyNote", function(opts)
  local arg1 = opts.fargs[1]

  create_daily_note({ day = arg1 })
end, {
  nargs = "?",
  complete = function(arg_lead)
    local options = { "tomorrow", "yesterday" }
    return vim.tbl_filter(function(val)
      return vim.startswith(val, arg_lead)
    end, options)
  end,
})

vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Wa", "wa", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("Wqa", "wqa", { bang = true })
