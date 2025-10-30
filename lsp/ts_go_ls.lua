---@type vim.lsp.Config
return {
  cmd = { vim.loop.os_homedir() .. "/dev/typescript-go/built/local/tsgo", "--lsp", "-stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
}
