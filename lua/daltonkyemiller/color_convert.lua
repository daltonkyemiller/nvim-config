local M = {}

M.pastel_formats = {
  "hex",
  "rgb",
  "rgb-float",
  "hsl",
  "hsv",
  "lch",
  "oklch",
  "lab",
  "oklab",
  "cmyk",
  "name",
  "luminance",
  "brightness",
  "rgb-r",
  "rgb-g",
  "rgb-b",
  "hsl-hue",
  "hsl-saturation",
  "hsl-lightness",
  "hsv-hue",
  "hsv-saturation",
  "hsv-value",
  "lch-lightness",
  "lch-chroma",
  "lch-hue",
  "oklch-lightness",
  "oklch-chroma",
  "oklch-hue",
  "lab-a",
  "lab-b",
  "oklab-l",
  "oklab-a",
  "oklab-b",
  "ansi-8bit",
  "ansi-24bit",
  "ansi-8bit-value",
  "ansi-8bit-escapecode",
  "ansi-24bit-escapecode",
}

function M.has_pastel()
  return vim.fn.executable("pastel") == 1
end

---@param color string
---@return string
function M.normalize_color(color)
  color = vim.trim(color)
  color = color:gsub("[,;]$", "")
  color = vim.trim(color)
  color = color:gsub("^[\"'`](.*)[\"'`]$", "%1")

  return color
end

---@return string[]
function M.get_pastel_formats()
  local result = vim.system({ "pastel", "format", "--help" }, { text = true }):wait()
  if result.code ~= 0 then return M.pastel_formats end

  local values = result.stdout:gsub("\n", " "):match("%[possible values:%s*(.-)%]")
  if not values then return M.pastel_formats end

  local formats = {}
  for format in values:gmatch("[^,]+") do
    table.insert(formats, vim.trim(format))
  end

  if #formats == 0 then return M.pastel_formats end

  return formats
end

---@param color string
---@param format string
---@return string? converted
---@return string? error
function M.format_color(color, format)
  local normalized = M.normalize_color(color)
  if normalized == "" then return nil, "No color provided" end

  local result = vim.system({ "pastel", "format", format, normalized }, { text = true }):wait()
  if result.code ~= 0 then return nil, vim.trim(result.stderr) end

  return vim.trim(result.stdout), nil
end

return M
