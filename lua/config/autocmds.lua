-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Auto restore session ]]
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local first_arg = vim.fn.argv()[1]
    if first_arg == nil or first_arg == '.' then
      require('persistence').load()
    end
  end,
  nested = true,
})
