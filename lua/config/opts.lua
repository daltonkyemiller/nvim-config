vim.o.expandtab = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- vim.cmd.colorscheme("catppuccin")
vim.cmd.colorscheme("kanagawa")

vim.o.spelllang = "en_us"
vim.o.spell = true
vim.o.spelloptions = "camel,noplainbuffer"

vim.o.laststatus = 3

vim.o.cursorline = true

vim.wo.relativenumber = true

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Smart indentation
vim.o.smartindent = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.splitright = true
vim.o.splitbelow = true

vim.filetype.add({
  filename = {
    Caddyfile = "caddy",
  },
  pattern = {
    ["%.env.*"] = "sh",
  },

  extension = {
    vert = "glsl",
    frag = "glsl",
    re = "reason",
  },
})

vim.g.bullets_enable_in_empty_buffers = 0

vim.g.neovide_opacity = 0.3
vim.g.neovide_normal_opacity = 0.3
