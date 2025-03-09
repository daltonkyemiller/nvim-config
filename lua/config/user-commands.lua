local create_daily_note = require("daltonkyemiller.daily_note").create_daily_note

vim.api.nvim_create_user_command("DailyNote", function(opts)
  local arg1 = opts.fargs[1]

  create_daily_note({ day = arg1 })
end, {
  nargs = "?",
  complete = function(arg_lead)
    local options = { "tomorrow", "yesterday" }
    return vim.tbl_filter(function(val)
      return vim.startswith(val, arg_lead)
    end, options)
  end,
})

vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Wa", "wa", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("Wqa", "wqa", { bang = true })

function ProcessQuickfixWithLSP()
  -- Get the quickfix list
  local qf_list = vim.fn.getqflist()

  -- Check if quickfix list is empty
  if #qf_list == 0 then
    print("Quickfix list is empty")
    return
  end

  -- Create a cancel flag
  _G.cancel_quickfix_processing = false

  -- Set up a temporary mapping to cancel the operation
  local old_mapping = vim.fn.maparg("<C-c>", "n")
  vim.api.nvim_set_keymap("n", "<C-c>", "", {
    noremap = true,
    callback = function()
      _G.cancel_quickfix_processing = true
      print("Cancelling quickfix processing...")
    end,
  })

  print("Processing " .. #qf_list .. " quickfix entries... (Press <C-c> to cancel)")

  -- Iterate through each entry
  for i, entry in ipairs(qf_list) do
    -- Check if operation was cancelled
    if _G.cancel_quickfix_processing then
      print("Operation cancelled by user")
      break
    end

    local bufnr = entry.bufnr
    local filename = vim.fn.bufname(bufnr)
    print("Processing entry " .. i .. "/" .. #qf_list .. ": " .. filename)

    -- Ensure we're using a proper buffer (might be invalid in quickfix)
    if bufnr == 0 or not vim.api.nvim_buf_is_valid(bufnr) then
      -- Try to open by filename instead
      vim.cmd("edit " .. vim.fn.fnameescape(filename))
      bufnr = vim.api.nvim_get_current_buf()
    else
      -- Open the file in a buffer
      vim.cmd("buffer " .. bufnr)
    end

    -- Force buffer to load fully
    vim.cmd("redraw")

    -- Wait longer for LSP to attach with better checking
    local lsp_ready = vim.wait(
      10000, -- Longer timeout (10 seconds)
      function()
        -- Check for cancellation during waiting too
        if _G.cancel_quickfix_processing then
          return true -- Exit the wait loop
        end

        -- Get clients attached to current buffer
        local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })

        -- Check specifically for the VTS client
        local vts_client_found = false
        for _, client in ipairs(clients) do
          -- Check for VTS client by name (may need to adjust the name based on your setup)
          if client.name == "vtsls" or client.name == "typescript-language-server" or client.name == "tsserver" then
            vts_client_found = true
            break
          end
        end

        if vts_client_found then
          -- Ensure the client is fully ready
          vim.cmd("sleep 500m") -- Small pause to ensure client is fully ready
          return true
        end
        return false
      end,
      250 -- Check more frequently
    )

    -- Check for cancellation again
    if _G.cancel_quickfix_processing then
      vim.cmd("bdelete")
      break
    end

    -- Process the current buffer if LSP is ready
    if lsp_ready and not _G.cancel_quickfix_processing then
      print("LSP attached, processing imports...")

      -- First, remove unused imports
      local success1, err1 = pcall(function()
        vim.cmd("VtsExec remove_unused_imports")
      end)

      if not success1 then
        print("Error removing unused imports: " .. tostring(err1))
      else
        print("Successfully removed unused imports")
      end

      -- Then, add missing imports
      local success2, err2 = pcall(function()
        vim.cmd("VtsExec add_missing_imports")
      end)

      if success2 then
        vim.cmd("write!")
        vim.cmd("bd!")
        print("Successfully processed " .. filename)
      else
        print("Error adding missing imports: " .. tostring(err2))
        vim.cmd("bd!")
      end
    else
      if not _G.cancel_quickfix_processing then
        print("Timeout waiting for LSP client to attach for: " .. filename)
        vim.cmd("bd!")
      end
    end
  end

  -- Clean up the mapping
  if old_mapping ~= "" then
    vim.api.nvim_set_keymap("n", "<C-c>", old_mapping, {})
  else
    vim.api.nvim_del_keymap("n", "<C-c>")
  end

  -- Reset the cancel flag
  _G.cancel_quickfix_processing = nil

  print(_G.cancel_quickfix_processing and "Operation was cancelled" or "Finished processing all quickfix entries")
end

vim.api.nvim_create_user_command("ProcessQuickfixImports", ProcessQuickfixWithLSP, {})
