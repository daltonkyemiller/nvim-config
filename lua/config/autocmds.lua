-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- [[ Auto restore session ]]
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local first_arg = vim.fn.argv()[1]
    if first_arg == "." then require("persistence").load() end
  end,
  nested = true,
})
-- custom parsers
vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    vim.notify("Treesitter parsers updated")
    require("nvim-treesitter.parsers").ghactions = {
      install_info = {
        url = "https://github.com/rmuir/tree-sitter-ghactions",
        queries = "queries",
      },
    }
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
    "yaml",
    "yaml.github",
    "json",
    "dockerfile",
    "caddy",
    "http",
    "terraform",
    "terraform-vars",
    "jinja"
  },
  callback = function()
    vim.treesitter.start()
  end,
})
