local version = vim.version()

---@type vim.lsp.Config
return {
  --NOTE: This name means that existing blink completion works
  name = "copilot",
  cmd = {
    "copilot-language-server",
    "--stdio",
  },
  init_options = {
    editorInfo = {
      name = "neovim",
      version = string.format("%d.%d.%d", version.major, version.minor, version.patch),
    },
    editorPluginInfo = {
      name = "Github Copilot LSP for Neovim",
      version = "0.0.1",
    },
  },
  settings = {
    nextEditSuggestions = {
      enabled = true,
    },
  },
  handlers = {
    ["textDocument/completion"] = function(err, result, ctx, config)
      P("YOUR TEXT DOCUMENT COMPLETION HANDLER")
    end,
    ["didChangeStatus"] = function() end,
    ["signIn"] = function() end,
  },
  root_dir = vim.uv.cwd(),
  on_init = function(client)
    local au = vim.api.nvim_create_augroup("copilot-language-server", { clear = true })

    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        local td_params = vim.lsp.util.make_text_document_params()
        client:notify("textDocument/didFocus", {
          textDocument = {
            uri = td_params.uri,
          },
        })
      end,
      group = au,
    })

    local debounced_request = require("daltonkyemiller.util").debounce(function(client)
      local params = vim.lsp.util.make_position_params(0, "utf-16")
      local bversion = vim.lsp.util.buf_versions[vim.api.nvim_get_current_buf()]
      params.textDocument.version = bversion
      client:request("textDocument/copilotInlineEdit", params, function(err, res)
        P(err)
        P(res)
      end)
    end, 100)

    function add(a, b)
      return a + b
    end


    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
      callback = function()
        debounced_request(client)
      end,
      group = au,
    })

    --NOTE: Inline Completions
    --TODO: We dont currently use this code path, so comment for now until a UI is built
    -- vim.api.nvim_create_autocmd("TextChangedI", {
    --     callback = function()
    --         inline_completion.request_inline_completion(2)
    --     end,
    --     group = au,
    -- })

    -- TODO: make this configurable for key maps, or just expose commands to map in config
    -- vim.keymap.set("i", "<c-i>", function()
    --     inline_completion.request_inline_completion(1)
    -- end)

    --NOTE: NES Completions
    -- local debounced_request =
    --   require("copilot-lsp.util").debounce(require("copilot-lsp.nes").request_nes, vim.g.copilot_nes_debounce or 500)
    -- vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
    --   callback = function()
    --     debounced_request(client)
    --   end,
    --   group = au,
    -- })
    --
    -- --NOTE: didFocus
    -- vim.api.nvim_create_autocmd("BufEnter", {
    --   callback = function()
    --     local td_params = vim.lsp.util.make_text_document_params()
    --     client:notify("textDocument/didFocus", {
    --       textDocument = {
    --         uri = td_params.uri,
    --       },
    --     })
    --   end,
    --   group = au,
    -- })
  end,
}
