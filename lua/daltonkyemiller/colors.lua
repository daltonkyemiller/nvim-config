local M = {}

---@param hex string
---@return number brightness from 0 to 1
function M.get_hex_brightness(hex)
  -- Remove "#" if present
  hex = hex:gsub("#", "")
  local r = tonumber(hex:sub(1, 2), 16) / 255
  local g = tonumber(hex:sub(3, 4), 16) / 255
  local b = tonumber(hex:sub(5, 6), 16) / 255

  -- Use the luminance formula (ITU-R BT.709)
  local brightness = 0.2126 * r + 0.7152 * g + 0.0722 * b
  return brightness
end

function M:get_palette()
  local c = require("kanagawa.lib.color")
  local colors = require("kanagawa.colors").setup({ theme = "dragon" })
  local more_saturated_palette = {}
  for k, v in pairs(colors.palette) do
    local brightness = self.get_hex_brightness(v)
    more_saturated_palette[k] = brightness > 0.5 and c(v):saturate(0.225):to_hex() or v
  end
  return more_saturated_palette
end

function M:export_palette_to_file()
  local palette = self:get_palette()
  local config_path = vim.fn.stdpath("config")
  
  -- Export Lua version
  local lua_file = config_path .. "/kanagawa_saturated_palette.lua"
  local lua_lines = {
    "-- Auto-generated Kanagawa saturated color palette",
    "-- Generated on: " .. os.date("%Y-%m-%d %H:%M:%S"),
    "",
    "return {",
  }
  
  -- Sort keys for consistent output
  local sorted_keys = {}
  for k in pairs(palette) do
    table.insert(sorted_keys, k)
  end
  table.sort(sorted_keys)
  
  for _, key in ipairs(sorted_keys) do
    local value = palette[key]
    table.insert(lua_lines, string.format('  %s = "%s",', key, value))
  end
  
  table.insert(lua_lines, "}")
  
  local file = io.open(lua_file, "w")
  if file then
    file:write(table.concat(lua_lines, "\n"))
    file:close()
    print("Lua palette exported to: " .. lua_file)
  else
    print("Error: Could not write to " .. lua_file)
  end
  
  -- Export JSON version
  local json_file = config_path .. "/kanagawa_saturated_palette.json"
  local json_lines = {
    "{",
  }
  
  for i, key in ipairs(sorted_keys) do
    local value = palette[key]
    local comma = i < #sorted_keys and "," or ""
    table.insert(json_lines, string.format('  "%s": "%s"%s', key, value, comma))
  end
  
  table.insert(json_lines, "}")
  
  local json_file_handle = io.open(json_file, "w")
  if json_file_handle then
    json_file_handle:write(table.concat(json_lines, "\n"))
    json_file_handle:close()
    print("JSON palette exported to: " .. json_file)
  else
    print("Error: Could not write to " .. json_file)
  end
end

-- Create user command to regenerate palette
vim.api.nvim_create_user_command("ExportKanagawaPalette", function()
  M:export_palette_to_file()
end, { desc = "Export Kanagawa saturated palette to file" })

return M
