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
  local current_buffer = vim.api.nvim_get_current_buf()
  local open_buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(open_buffers) do
    if buf ~= current_buffer then vim.api.nvim_buf_delete(buf, { force = true }) end
  end
end, { desc = "[B]uffer Delete [O]thers" })

-- Open lazy plugin manager
vim.keymap.set("n", "<leader>l", "<Cmd>Lazy<CR>", { desc = "Open [L]azy plugin manager" })

-- Open new empty buffer
vim.keymap.set("n", "<leader>bn", "<Cmd>enew<CR>", { desc = "[B]uffer [N]ew" })
