vim.lsp.config("*", {
  root_markers = { ".git" },
  on_attach = require("daltonkyemiller.lsp").global_on_attach,
})

vim.lsp.enable({
  -- "copilot",
  "docker_compose_ls",
  "dockerfile_ls",
  "gh_actions_ls",
  "python_ls",
  "yaml_ls",
  "qmlls",
  "gopls",
  "glsl_ls",
  "bashls",
  "hyprls",
  "emmet",
  "rust",
  "css",
  "json",
  "lua_ls",
  "toml",
  "vtsls",
  "prisma",
  "biome",
  "tailwindcss",
})
