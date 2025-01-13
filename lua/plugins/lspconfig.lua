-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then desc = "LSP: " .. desc end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  if client.name == "vtsls" then
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
      vim.lsp.buf.execute_command({
        command = "typescript.openTsServerLog",
      })
    end)

    nmap("<leader>cR", function()
      vim.lsp.buf.execute_command({
        command = "typescript.reloadProjects",
      })
    end, "[C]ode [R]estart Server")

    nmap("<leader>cV", function()
      vim.lsp.buf.execute_command({
        command = "typescript.selectTypeScriptVersion",
      })
    end, "[C]ode [V]ersion")

    nmap("<leader>cD", function()
      local position_params = vim.lsp.util.make_position_params()

      vim.lsp.buf.execute_command({
        command = "typescript.goToSourceDefinition",
        arguments = { vim.api.nvim_buf_get_name(0), position_params.position },
      })
    end, "[C]ode [D]efinition")
  end

  nmap("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
  nmap("<leader>cd", vim.diagnostic.open_float, "[C]ode [D]iagnostics")
  nmap("<leader>ci", function()
    local is_enabled = vim.lsp.inlay_hint.is_enabled({})
    vim.lsp.inlay_hint.enable(not is_enabled)
  end, "[C]ode [I]nlay Hints")

  vim.keymap.set({ "n", "x" }, "<leader>ca", function()
    vim.lsp.buf.code_action({ context = { only = { "quickfix", "refactor", "source" } } })
  end, { desc = "[C]ode [A]ction" })

  -- nmap("<leader>ca", function()
  --   vim.lsp.buf.code_action({ context = { only = { "quickfix", "refactor", "source" } } })
  -- end, "[C]ode [A]ction")

  -- nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
  -- nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  -- nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
  nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
  -- nmap("<leader>d", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  -- nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")
end

local servers = {
  vtsls = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
          entriesLimit = 25,
        },
      },
    },
    typescript = {
      maxTsServerMemory = 8192,
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
      },
    },
  },
  prismals = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      diagnostics = { disable = { "missing-fields" } },
    },
  },
  glsl_analyzer = {},
  biome = {},
  tailwindcss = {
    tailwindCSS = {
      experimental = {
        -- classRegex = {
        --   {
        --     "cn\\(([^]*)\\)",
        --     "(?:'|\"|`)([^\"'`]*)(?:'|\"|`)",
        --   },
        -- },
      },
    },
  },
  astro = {},
}

local vtsls_handlers = {
  ["workspace/executeCommand"] = function(err, result, ctx, config)
    if ctx.params.command ~= "typescript.goToSourceDefinition" then return end
    vim.print(vim.inspect(result))
    if result == nil or #result == 0 then return end

    vim.lsp.util.jump_to_location(result[1], "utf-8")
  end,
}

--- @type LazySpec
return {
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    {
      "williamboman/mason.nvim",
      opts = function()
        --- @type MasonSettings
        return {
          ui = {
            icons = require("nvim-nonicons.extentions.mason").icons,
          },
        }
      end,
    },
    { "folke/neodev.nvim", config = true },
    {
      "williamboman/mason-lspconfig.nvim",
      config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        require("mason-lspconfig").setup({
          ensure_installed = vim.tbl_keys(servers),
          handlers = {
            function(server_name)
              local handlers = server_name == "vtsls" and vtsls_handlers or {}

              require("lspconfig")[server_name].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = servers[server_name],
                filetypes = (servers[server_name] or {}).filetypes,
                handlers = handlers,
              })
            end,
          },
        })
      end,
    },
  },
}
