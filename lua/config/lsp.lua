---@param bufnr number
local make_nmap = function(bufnr)
  ---@param keys string
  ---@param func function
  ---@param desc string
  local nmap = function(keys, func, desc)
    if desc then desc = "LSP: " .. desc end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end
  return nmap
end

local global_on_attach = function(client, bufnr)
  local nmap = make_nmap(bufnr)

  nmap("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
  nmap("<leader>cd", vim.diagnostic.open_float, "[C]ode [D]iagnostics")
  nmap("<leader>ci", function()
    local is_enabled = vim.lsp.inlay_hint.is_enabled({})
    vim.lsp.inlay_hint.enable(not is_enabled)
  end, "[C]ode [I]nlay Hints")

  vim.keymap.set({ "n", "x" }, "<leader>ca", function()
    vim.lsp.buf.code_action()
  end, { desc = "[C]ode [A]ction" })

  nmap("<leader>ca", function()
    vim.lsp.buf.code_action({ context = { diagnostics = {}, only = { "quickfix", "refactor", "source" } } })
  end, "[C]ode [A]ction")

  nmap("gd", require("snacks.picker").lsp_definitions, "[G]oto [D]efinition")
  nmap("gD", require("snacks.picker").lsp_type_definitions, "[G]oto [D]efinition")
  -- nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  -- nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  -- nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  -- nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
  -- nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
  -- nmap("<leader>d", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  -- nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  -- nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")
end
vim.lsp.config("*", {
  on_attach = global_on_attach,
})

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml" },
  Lua = {
    workspace = { checkThirdParty = false },
    telemetry = { enable = false },
    -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
    diagnostics = { disable = { "missing-fields" } },
  },
})

vim.lsp.config("vtsls", {
  on_attach = function(client, bufnr)
    global_on_attach(client, bufnr)

    local nmap = make_nmap(bufnr)

    nmap("<leader>co", function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { "source.removeUnused.ts" },
          diagnostics = {},
        },
      })
    end, "[C]ode [O]rganize Imports")

    nmap("<leader>cu", function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { "source.removeUnused.ts" },
          diagnostics = {},
        },
      })
    end, "[C]ode Remove [U]nused Code")

    nmap("<leader>cl", function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { "source.fixAll.biome" },
          diagnostics = {},
        },
      })
    end, "[C]ode [L]int Fix All")

    nmap("<leader>cL", function()
      client:exec_cmd({
        command = "typescript.openTsServerLog",
      })
    end, "[C]ode [L]og")

    nmap("<leader>cR", function()
      client:exec_cmd({
        command = "typescript.reloadProjects",
      })
    end, "[C]ode [R]estart Server")

    nmap("<leader>cV", function()
      client:exec_cmd({
        command = "typescript.selectTypeScriptVersion",
      })
    end, "[C]ode [V]ersion")

    nmap("<leader>cD", function()
      local position_params = vim.lsp.util.make_position_params(0, "utf-8")

      client:exec_cmd({
        command = "typescript.goToSourceDefinition",
        arguments = { vim.api.nvim_buf_get_name(0), position_params.position },
      })
    end, "[C]ode [D]efinition")
  end,
  vtsls = {
    autoUseWorkspaceTsdk = true,
    experimental = {
      completion = {
        enableServerSideFuzzyMatch = true,
      },
    },
    typescript = {
      preferences = {
        includeCompletionsForImportStatements = true,
      },
      maxTsServerMemory = 16384,
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
        variableTypes = {
          enabled = true,
        },
        propertyDeclarationTypes = {
          enabled = true,
        },
        functionLikeReturnTypes = {
          enabled = true,
        },
        chainedCalls = {
          enabled = true,
        },
      },
    },
  },
})

vim.lsp.config("tailwindcss", {
  filetypes = { "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact" },
})

vim.lsp.config("json-lsp", {
  filetypes = { "json", "jsonc" },
  cmd = { "vscode-json-language-server", "--stdio" },
})

vim.lsp.config("css-lsp", {
  filetypes = { "css", "scss", "less" },
  cmd = { "vscode-css-language-server", "--stdio" },
})

vim.lsp.config("prismals", {
  filetypes = { "prisma" },
  cmd = { "prisma-language-server", "--stdio" },
})

vim.lsp.config("taplo", {
  filetypes = { "toml" },
  cmd = { "taplo", "lsp", "stdio" },
  -- ---@param fname string
  -- root_dir = function(fname)
  --   return vim.fs.dirname(vim.fs.find(".git", {
  --     follow = true,
  --     upward = true,
  --   })[1])
  -- end,
  settings = {
    evenBetterToml = {
      schema = {
        associations = {
          ["stylua.toml"] = "https://raw.githubusercontent.com/SchemaStore/schemastore/refs/heads/master/src/schemas/json/stylua.json",
          [".stylua.toml"] = "https://raw.githubusercontent.com/SchemaStore/schemastore/refs/heads/master/src/schemas/json/stylua.json",
        },
      },
    },
  },
})

vim.lsp.config("rust-analyzer", {
  filetypes = { "rust" },
  cmd = { "rust-analyzer" },
})

vim.lsp.enable({
  "rust-analyzer",
  "css-lsp",
  "json-lsp",
  "lua_ls",
  "taplo",
  "vtsls",
  "prismals",
  "glsl_analyzer",
  "biome",
  "tailwindcss",
  "astro",
  "reason_ls",
})
