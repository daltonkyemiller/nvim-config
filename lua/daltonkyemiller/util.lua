local M = {}

---@param lsp_name string
M.is_specific_lsp_attached_to_buffer = function(lsp_name)
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client.name == lsp_name then return true end
  end
  return false
end

return M
