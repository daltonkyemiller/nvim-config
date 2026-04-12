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

local function normalize_path(path)
  if not path or path == "" then return nil end
  return vim.uv.fs_realpath(path) or path
end

local function is_readable_file(path)
  return path and path ~= "" and vim.fn.filereadable(path) == 1
end

local function in_cwd(path, cwd)
  return path == cwd or vim.startswith(path, cwd .. "/")
end

local function unique_paths(paths, max_items)
  local out = {}
  local seen = {}
  for _, path in ipairs(paths) do
    if path and not seen[path] then
      seen[path] = true
      out[#out + 1] = path
      if #out >= max_items then break end
    end
  end
  return out
end

local function write_tmux_picker_context()
  local cwd = normalize_path(vim.uv.cwd())
  if not cwd then return end

  local state_dir = vim.fn.expand("~/.local/state/agent-mux/nvim-context")
  vim.fn.mkdir(state_dir, "p")

  local hash = vim.fn.sha256(cwd):sub(1, 16)
  local state_file = state_dir .. "/" .. hash .. ".json"

  local current_name = normalize_path(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
  local current_file = is_readable_file(current_name) and current_name or nil
  if current_file and not in_cwd(current_file, cwd) then current_file = nil end

  local alternate_num = vim.fn.bufnr("#")
  local alternate_name = alternate_num > 0 and normalize_path(vim.api.nvim_buf_get_name(alternate_num)) or nil
  local alternate_file = is_readable_file(alternate_name) and alternate_name or nil
  if alternate_file and not in_cwd(alternate_file, cwd) then alternate_file = nil end

  local open_buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      local name = normalize_path(vim.api.nvim_buf_get_name(buf))
      if is_readable_file(name) and in_cwd(name, cwd) then
        open_buffers[#open_buffers + 1] = name
      end
    end
  end

  local recent_files = {}
  for _, oldfile in ipairs(vim.v.oldfiles or {}) do
    local name = normalize_path(oldfile)
    if is_readable_file(name) and in_cwd(name, cwd) then
      recent_files[#recent_files + 1] = name
    end
  end

  local payload = {
    cwd = cwd,
    tmux_pane = vim.env.TMUX_PANE or "",
    updated_at = os.time(),
    current_file = current_file,
    alternate_file = alternate_file,
    open_buffers = unique_paths(open_buffers, 20),
    recent_files = unique_paths(recent_files, 50),
  }

  local ok, encoded = pcall(vim.json.encode, payload)
  if not ok then return end
  vim.fn.writefile({ encoded }, state_file)
end

local picker_context_group = vim.api.nvim_create_augroup("TmuxAgentPickerContext", { clear = true })
local picker_context_timer = nil

local function schedule_tmux_picker_context_write()
  if picker_context_timer then
    picker_context_timer:stop()
    picker_context_timer:close()
    picker_context_timer = nil
  end

  picker_context_timer = vim.uv.new_timer()
  if not picker_context_timer then
    write_tmux_picker_context()
    return
  end

  picker_context_timer:start(150, 0, function()
    picker_context_timer:stop()
    picker_context_timer:close()
    picker_context_timer = nil
    vim.schedule(write_tmux_picker_context)
  end)
end

vim.api.nvim_create_autocmd({
  "VimEnter",
  "BufEnter",
  "WinEnter",
  "BufWritePost",
  "DirChanged",
}, {
  group = picker_context_group,
  callback = schedule_tmux_picker_context_write,
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
