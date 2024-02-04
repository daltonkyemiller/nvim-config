-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'v', 'n' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


-- delete window
-- vim.keymap.set('n', "<leader>wd", ":q<CR>", { desc = "[W]indow [D]elete", noremap = true, silent = true })
vim.keymap.set('n', "|", "<C-w>v", { desc = "Split window vertically", noremap = true, silent = true })
vim.keymap.set('n', "\\", "<C-w>s", { desc = "Split window horizontally", noremap = true, silent = true })


-- keep cursor in center when scrolling
vim.keymap.set('n', "<C-u>", "<C-u>zz", { desc = "Move cursor up half page", noremap = true, silent = true })
vim.keymap.set('n', "<C-d>", "<C-d>zz", { desc = "Move cursor down half page", noremap = true, silent = true })

vim.keymap.set('n', "<leader>bd", ":bd<CR>", { desc = "[B]uffer [D]elete", noremap = true, silent = true })
