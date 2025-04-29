---@type vim.lsp.Config
return {
  filetypes = { "rust" },
  root_markers = { "Cargo.toml" },
  cmd = { "rust-analyzer" },
}
