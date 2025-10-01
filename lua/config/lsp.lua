vim.lsp.config("*", {
  root_markers = { ".git" },
  on_attach = require("daltonkyemiller.lsp").global_on_attach,
})

vim.lsp.enable({
  -- "copilot",
  -- "ast_grep_ls",
  "copilot_ls",
  "jinja_ls",
  "ansible_ls",
  "docker_compose_ls",
  "dockerfile_ls",
  "gh_actions_ls",
  "python_ls",
  "yaml_ls",
  "qmlls",
  -- "gopls",
  -- "glsl_ls",
  "bashls",
  -- "hyprls",
  "emmet",
  "rust",
  "css",
  "json",
  "lua_ls",
  -- "toml",
  "vtsls",
  "prisma",
  "biome",
  "tailwindcss",
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "",
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local buffer = ev.buf

    if not client then return end

    -- if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
    --   vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
    --   vim.lsp.completion.enable(true, client.id, buffer, { autotrigger = true })
    -- end
    
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion) then
      vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
      vim.lsp.inline_completion.enable(true)
    end
  end,
})
