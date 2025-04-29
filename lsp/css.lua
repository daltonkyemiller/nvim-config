---@type vim.lsp.Config
return {
  filetypes = { "css", "scss", "less" },
  cmd = { "vscode-css-language-server", "--stdio" },
}
