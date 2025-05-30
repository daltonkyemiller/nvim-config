---@type vim.lsp.Config
return {
  filetypes = { "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  cmd = { "tailwindcss-language-server", "--stdio" },
  settings = {
    tailwindCSS = {
      classFunctions = { "utils.cn", "cn", "cna", "clsx" },
    },
  },
}
