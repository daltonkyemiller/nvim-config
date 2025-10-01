---@type vim.lsp.Config
return {
  filetypes = { "typescript", "typescriptreact" },
  cmd = { "vtsls", "--stdio" },
  on_attach = function(client, bufnr)
    require("daltonkyemiller.lsp").global_on_attach(client, bufnr)

    local nmap = require("daltonkyemiller.util").make_nmap(bufnr)

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
        title = "Open TS Server Log",
        command = "typescript.openTsServerLog",
      })
    end, "[C]ode [L]og")

    nmap("<leader>cR", function()
      client:exec_cmd({
        title = "Reload Projects",
        command = "typescript.reloadProjects",
      })
    end, "[C]ode [R]estart Server")

    nmap("<leader>cV", function()
      client:exec_cmd({
        title = "Select TypeScript Version",
        command = "typescript.selectTypeScriptVersion",
      })
    end, "[C]ode [V]ersion")

    nmap("<leader>cD", function()
      local position_params = vim.lsp.util.make_position_params(0, "utf-8")

      client:exec_cmd({
        title = "Go to Source Definition",
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
      tsserver = {
        maxTsServerMemory = 16384,
      },
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
}
