vim.lsp.config("*", {
  root_markers = { ".git" },
  on_attach = require("daltonkyemiller.lsp").global_on_attach,
})

vim.lsp.enable({
  -- "copilot",
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
