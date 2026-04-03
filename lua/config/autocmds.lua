-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- [[ Auto restore session ]]
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local first_arg = vim.fn.argv()[1]
    if first_arg == "." then require("persistence").load() end
  end,
  nested = true,
})
-- Enable treesitter highlighting for filetypes using external parsers
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
    "astro",
    "json",
    "dockerfile",
    "caddy",
    "http",
    "terraform",
    "terraform-vars",
    "jinja",
    "prisma",
    "python",
    "css",
    "html",
    "rust",
    "go",
    "sql",
  },
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- custom parsers
vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    vim.notify("Treesitter parsers updated")
    require("nvim-treesitter.parsers").ghactions = {
      install_info = {
        url = "https://github.com/rmuir/tree-sitter-ghactions",
        queries = "queries",
      },
    }
  end,
})


local inactive_ns = vim.api.nvim_create_namespace("InactiveWindowDim")
local last_active_normal_win = nil

local function is_normal_window(win)
  if not win or not vim.api.nvim_win_is_valid(win) then return false end
  return vim.api.nvim_win_get_config(win).relative == ""
end

local function dim_color(color, factor)
  if type(color) ~= "number" then return color end

  local r = math.floor(color / 0x10000) % 0x100
  local g = math.floor(color / 0x100) % 0x100
  local b = color % 0x100

  r = math.floor(r * factor + 0.5)
  g = math.floor(g * factor + 0.5)
  b = math.floor(b * factor + 0.5)

  return r * 0x10000 + g * 0x100 + b
end

local function rebuild_inactive_highlights()
  local groups = vim.fn.getcompletion("", "highlight")

  for _, group in ipairs(groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if ok and hl and not vim.tbl_isempty(hl) then
      local dimmed = {
        fg = dim_color(hl.fg, 0.72),
        bg = hl.bg,
        sp = dim_color(hl.sp, 0.72),
        blend = hl.blend,
        bold = hl.bold,
        standout = hl.standout,
        underline = hl.underline,
        undercurl = hl.undercurl,
        underdouble = hl.underdouble,
        underdotted = hl.underdotted,
        underdashed = hl.underdashed,
        strikethrough = hl.strikethrough,
        italic = hl.italic,
        reverse = hl.reverse,
        nocombine = hl.nocombine,
      }

      vim.api.nvim_set_hl(inactive_ns, group, dimmed)
    end
  end
end

local function resolve_active_normal_win()
  local current_win = vim.api.nvim_get_current_win()
  if is_normal_window(current_win) then
    last_active_normal_win = current_win
    return current_win
  end

  if is_normal_window(last_active_normal_win) then return last_active_normal_win end

  local alternate_win = vim.fn.win_getid(vim.fn.winnr("#"))
  if is_normal_window(alternate_win) then
    last_active_normal_win = alternate_win
    return alternate_win
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_normal_window(win) then
      last_active_normal_win = win
      return win
    end
  end

  return nil
end

local function apply_inactive_window_dimming()
  local active_win = resolve_active_normal_win()

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_normal_window(win) then
      vim.api.nvim_win_set_hl_ns(win, win == active_win and 0 or inactive_ns)
    else
      vim.api.nvim_win_set_hl_ns(win, 0)
    end
  end
end

local dim_windows_group = vim.api.nvim_create_augroup("DimInactiveWindows", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = dim_windows_group,
  callback = function()
    rebuild_inactive_highlights()
    apply_inactive_window_dimming()
  end,
})

vim.api.nvim_create_autocmd({
  "VimEnter",
  "WinEnter",
  "WinNew",
  "WinClosed",
  "BufWinEnter",
  "FocusGained",
  "CmdlineEnter",
  "CmdlineLeave",
  "ModeChanged",
}, {
  group = dim_windows_group,
  callback = function()
    vim.schedule(apply_inactive_window_dimming)
  end,
})

rebuild_inactive_highlights()
vim.schedule(apply_inactive_window_dimming)
