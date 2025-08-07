---@type vim.lsp.Config
return {
  cmd = { "docker-compose-langserver", "--stdio" },
  filetypes = { "yaml.docker-compose" },
  root_markers = { ".git" },
  init_options = {},
}
