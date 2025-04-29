local M = {}

---@param lsp_name string
function M.is_specific_lsp_attached_to_buffer(lsp_name)
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client.name == lsp_name then return true end
  end
  return false
end

function M.make_nmap(bufnr)
  ---@param keys string
  ---@param func function
  ---@param desc string
  local nmap = function(keys, func, desc)
    if desc then desc = "LSP: " .. desc end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end
  return nmap
end

---@param fn fun(...: any)
---@param delay integer
function M.debounce(fn, delay)
  local timer = vim.uv.new_timer()
  if not timer then error("Failed to create timer") end
  return function(...)
    local argv = vim.F.pack_len(...)
    timer:start(delay, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(vim.F.unpack_len(argv))
    end)
  end
end

return M
