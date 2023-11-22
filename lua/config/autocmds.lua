-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https:/github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- vim.api.nvim_create_autocmd("VimLeavePre", {
--   callback = function()
--     local mini_sessions = require("mini.sessions")
--     local util = require("daltonkyemiller.util")
--     mini_sessions.write(util.get_dir_name(), {
--       force = true,
--     })
--   end,
-- })
--
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("persistence").load()
  end,
  nested = true,
})
