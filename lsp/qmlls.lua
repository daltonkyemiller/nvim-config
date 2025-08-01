---@type vim.lsp.Config
return {
  filetypes = { "qml" },
  cmd = { "/usr/lib/qt6/bin/qmlls", "-E" },
}
