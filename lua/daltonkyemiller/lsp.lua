local M = {}

function M.global_on_attach(client, bufnr)
  local nmap = require("daltonkyemiller.util").make_nmap(bufnr)

  nmap("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
  nmap("<leader>cd", vim.diagnostic.open_float, "[C]ode [D]iagnostics")
  -- nmap("<leader>ci", function()
  --   local is_enabled = vim.lsp.inlay_hint.is_enabled({})
  --   vim.lsp.inlay_hint.enable(not is_enabled)
  -- end, "[C]ode [I]nlay Hints")

  vim.keymap.set({ "n", "x" }, "<leader>ca", function()
    vim.lsp.buf.code_action()
  end, { desc = "[C]ode [A]ction" })

  nmap("<leader>ca", function()
    vim.lsp.buf.code_action({ context = { diagnostics = {}, only = { "quickfix", "refactor", "source" } } })
  end, "[C]ode [A]ction")

  nmap("gd", require("snacks.picker").lsp_definitions, "[G]oto [D]efinition")
  nmap("gD", require("snacks.picker").lsp_type_definitions, "[G]oto [D]efinition")

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

return M
