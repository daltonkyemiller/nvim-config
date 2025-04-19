local M = {}

--- @param path string
function M.load(path)
  local file = io.open(path, "r")
  if not file then return end

  for line in file:lines() do
    for key, value in string.gmatch(line, "([%w_]+)%s*=%s*['\"]?([^'\"]+)['\"]?") do
      vim.env[key] = value
    end
  end

  file:close()
end

return M
