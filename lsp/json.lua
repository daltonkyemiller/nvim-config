---@type vim.lsp.Config
return {
  filetypes = { "json", "jsonc" },
  cmd = { "vscode-json-language-server", "--stdio" },
}
