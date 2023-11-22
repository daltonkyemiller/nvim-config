-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
vim.keymap.set("n", "\\", "<cmd>split<cr>", { desc = "Horizontal Split" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { remap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { remap = true })

vim.keymap.set(
  "n",
  "gv",
  "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>",
  { desc = "Go to definition in vertical split" }
)

vim.keymap.set(
  "n",
  "<leader>fs",
  require("telescope.builtin").lsp_dynamic_workspace_symbols,
  { desc = "Search for a workspace symbol" }
)

require("lazyvim.util").lsp.on_attach(function(_, buffer)
  vim.keymap.set("n", "<leader>co", function()
    vim.lsp.buf.execute_command({
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(0) },
    })
  end, { buffer = buffer, desc = "Organize Imports" })
  vim.keymap.set("n", "<leader>cR", "<Cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = buffer })
end)
