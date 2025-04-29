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

return M
