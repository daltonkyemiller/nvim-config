local M = {}

M.get_dir_name = function()
  return vim.fn.fnamemodify(vim.loop.cwd(), ":t")
end

return M
