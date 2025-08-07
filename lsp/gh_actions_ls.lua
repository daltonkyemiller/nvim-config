---@type vim.lsp.Config
return {
  cmd = { "gh-actions-language-server", "--stdio" },
  filetypes = { "yaml.github" },
  root_markers = { ".github" },
  init_options = {},
}
