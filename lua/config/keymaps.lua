-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "v", "n" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })

-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- split window vertically
vim.keymap.set("n", "|", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "\\", ":split<CR>", { desc = "Split window horizontally" })

-- keep cursor in center when scrolling
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move cursor up half page", noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move cursor down half page", noremap = true, silent = true })

-- [[ Buffer keymaps]]
-- Delete buffer
vim.keymap.set("n", "<leader>bd", "<Cmd>bd<CR>", { desc = "[B]uffer [D]elete", noremap = true, silent = true })
vim.keymap.set("n", "<leader>bo", function()
  local current_windows = vim.api.nvim_list_wins()
  local current_buffers = {}
  for _, win in ipairs(current_windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    table.insert(current_buffers, buf)
  end
  local open_buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(open_buffers) do
    if not vim.tbl_contains(current_buffers, buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
  end
end, { desc = "[B]uffer Delete [O]thers" })

-- Open lazy plugin manager
vim.keymap.set("n", "<leader>l", "<Cmd>Lazy<CR>", { desc = "Open [L]azy plugin manager" })

-- Open new empty buffer
vim.keymap.set("n", "<leader>bn", "<Cmd>enew<CR>", { desc = "[B]uffer [N]ew" })

vim.keymap.set("n", "gf", require("daltonkyemiller.fig_comment").create_fig_comment, { desc = "Create [F]ig Comment" })

vim.keymap.set("v", "<leader>r", function()
  local pos1 = vim.fn.getpos("v")
  local pos2 = vim.fn.getpos(".")

  local text = vim.fn.getregion(pos1, pos2)[1]

  local escape_pattern = "/\\.*$^~[]"
  -- Escape special characters
  local escaped_text = vim.fn.escape(text, escape_pattern)

  vim.ui.input({
    prompt = "Replace with: ",
  }, function(replace_with)
    if replace_with == "" then return end
    replace_with = vim.fn.escape(replace_with, escape_pattern)

    vim.cmd("%s/" .. escaped_text .. "/" .. replace_with .. "/g")
  end)
end, { noremap = true, desc = "[R]eplace visual selection in file" })
