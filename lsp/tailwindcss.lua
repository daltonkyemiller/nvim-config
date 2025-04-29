---@type vim.lsp.Config
return {
  filetypes = { "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  cmd = { "tailwindcss-language-server", "--stdio" },
}
