--- @type LazySpec
return {
  "bullets-vim/bullets.vim",
  ft = { "markdown", "text", "gitcommit", "scratch" },
  config = function()
    vim.g.bullets_enable_in_empty_buffers = 0
  end,
}
