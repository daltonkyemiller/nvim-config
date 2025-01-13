local M = {}

M.create_fig_comment = function()
  vim.ui.input({ prompt = "Enter text:" }, function(input)
    if not input then return end
    vim.cmd("read !figlet " .. input)
    require("Comment.api").toggle.linewise("line")
  end)
end

return M
