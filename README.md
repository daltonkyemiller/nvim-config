# 🚀 Dalton's Neovim Configuration

A modern, AI-enhanced Neovim configuration built for full-stack development with a focus on TypeScript/React, performance, and developer experience.

## ✨ Features

### 🤖 AI Integration
- **Claude Code** - Custom Claude AI integration for enhanced coding assistance
- **Supermaven** - AI-powered code completion
- **Multiple AI backends** - Avante and CodeCompanion ready for activation

### ⚡ Modern Development Stack
- **Blink.cmp** - Lightning-fast completion engine
- **Comprehensive LSP** - Full language server support with Mason
- **Smart formatting** - Conform with intelligent formatter selection
- **Advanced syntax** - Treesitter with custom text objects

### 🎨 Beautiful UI
- **Snacks.nvim** - Modern fuzzy finder with dropdown layout
- **Neo-tree** - Floating file explorer with system integration
- **Kanagawa theme** - Custom saturated palette with transparency
- **Lualine** - Clean status line with theme integration

### 🔧 Developer Tools
- **Git integration** - Gitsigns, Lazygit, and git blame
- **Session management** - Automatic session persistence
- **Daily notes** - Automated note creation with TODO carryover
- **Docker integration** - Lazydocker terminal integration

## 🌐 Language Support

### Primary Languages (Full LSP + Formatting)
- **JavaScript/TypeScript** - VTSLS + Biome/Prettier
- **React/JSX** - Complete JSX support with custom text objects
- **Rust** - rust-analyzer integration
- **Go** - gopls + gofmt
- **Lua** - lua_ls + stylua
- **Python** - Full LSP support

### Additional Languages
- **Web**: HTML, CSS, Astro
- **Database**: SQL (with dbee), Prisma
- **Systems**: Bash, GLSL, QML
- **Config**: TOML, YAML, JSON
- **Documentation**: Markdown with live rendering

## 🎨 Themes

- **Kanagawa** (Primary) - Custom saturated palette with transparency
- **Catppuccin** - Mocha variant with custom highlights
- **Rose Pine** - Available but disabled

All themes feature transparent backgrounds and custom highlight groups.

## ⚙️ Installation

### Prerequisites
- Neovim >= 0.10.0
- Git
- A Nerd Font (for icons)
- Node.js (for LSP servers)
- Ripgrep (for searching)

### Quick Setup
```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this configuration
git clone <your-repo-url> ~/.config/nvim

# Start Neovim (plugins will auto-install)
nvim
```

### Optional Dependencies
```bash
# For enhanced functionality
npm install -g @biomejs/biome prettier
cargo install stylua
go install golang.org/x/tools/gopls@latest
```

## 🔑 Key Mappings

### Leader Key: `<Space>`

#### File Operations
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>fr` - Recent files

#### Buffer Management
- `<leader>bd` - Delete buffer
- `<leader>bo` - Delete other buffers
- `<leader>bn` - New buffer

#### Code Actions
- `<leader>cf` - Format code
- `<leader>ca` - Code actions
- `<leader>cr` - Rename symbol
- `gd` - Go to definition
- `gr` - Go to references

#### Git
- `<leader>gg` - Lazygit
- `<leader>gb` - Git blame
- `<leader>gh` - Git browse

#### Utilities
- `<leader>l` - Lazy plugin manager
- `<leader>dd` - Lazydocker
- `|` - Vertical split
- `\\` - Horizontal split

## 🏗️ Configuration Structure

```
├── lua/
│   ├── config/           # Core configuration
│   │   ├── keymaps.lua   # Key mappings
│   │   ├── lsp.lua       # LSP configuration
│   │   └── opts.lua      # Vim options
│   ├── daltonkyemiller/  # Custom utilities
│   │   ├── colors.lua    # Theme customizations
│   │   ├── daily_note.lua # Daily notes system
│   │   └── util.lua      # Helper functions
│   └── plugins/          # Plugin configurations
├── lsp/                  # LSP server configs
├── snippets/             # Custom snippets
└── after/queries/        # Treesitter queries
```

## 🎯 Highlights

### Daily Notes System
Automatically creates daily notes with TODO carryover from previous days:
```markdown
---
date: 2024-01-15
tags: [daily]
---

# Daily Note - January 15, 2024

## TODOs
- [ ] Carried over from previous day
- [ ] New tasks for today
```

### Smart Formatting
Automatically detects and uses the appropriate formatter:
- Biome for projects with `biome.json`
- Prettier for projects with `.prettierrc`
- Language-specific formatters as fallback

### Custom LSP Integration
Enhanced LSP experience with:
- Floating diagnostics
- Symbol search across workspace
- Custom rename integration with file explorer
- Intelligent hover information

## 🔧 Customization

### Adding New Languages
1. Add LSP config in `lsp/your-language.lua`
2. Enable in `lua/config/lsp.lua`
3. Add formatter in `lua/plugins/conform.lua`

### Theme Customization
Modify `lua/daltonkyemiller/colors.lua` to adjust the color palette:
```lua
-- Increase saturation
local function saturate_color(color, factor)
  -- Custom saturation logic
end
```

### Custom Keymaps
Add personal keymaps in `lua/config/keymaps.lua`:
```lua
vim.keymap.set("n", "<leader>xx", function()
  -- Your custom function
end, { desc = "Custom action" })
```
