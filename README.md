# nvim

My Neovim config. Built around TypeScript/React but handles most things I throw at it.

---

### <picture><source media="(prefers-color-scheme: dark)" srcset=".github/icons/brain-sparkle-light.svg"><img src=".github/icons/brain-sparkle-dark.svg" width="18"></picture> AI

- [sidekick.nvim](https://github.com/folke/sidekick.nvim) — Claude Code, OpenCode, Gemini, etc. in a split with tmux persistence
- [supermaven](https://github.com/supermaven-inc/supermaven-nvim) — inline completions

### <picture><source media="(prefers-color-scheme: dark)" srcset=".github/icons/code-editor-light.svg"><img src=".github/icons/code-editor-dark.svg" width="18"></picture> Editor

- [blink.cmp](https://github.com/Saghen/blink.cmp) — completion engine
- LSP via Mason — vtsls, rust-analyzer, gopls, lua_ls, pyright, etc.
- [conform.nvim](https://github.com/stevearc/conform.nvim) — formatting (biome, prettier, stylua, gofmt)
- Treesitter with custom text objects and injection queries

### <picture><source media="(prefers-color-scheme: dark)" srcset=".github/icons/color-palette-light.svg"><img src=".github/icons/color-palette-dark.svg" width="18"></picture> UI

- [kanagawa](https://github.com/rebelot/kanagawa.nvim) — primary theme, custom saturated palette, transparent bg
- [snacks.nvim](https://github.com/folke/snacks.nvim) — picker, notifications, terminal, scratch buffers
- [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) — floating file explorer

### <picture><source media="(prefers-color-scheme: dark)" srcset=".github/icons/wrench-light.svg"><img src=".github/icons/wrench-dark.svg" width="18"></picture> Tools

- [gitsigns](https://github.com/lewis6991/gitsigns.nvim) + lazygit
- Session persistence via [auto-session](https://github.com/rmagatti/auto-session)
- Daily notes with TODO carryover
- Lazydocker

---

## <picture><source media="(prefers-color-scheme: dark)" srcset=".github/icons/code-branch-light.svg"><img src=".github/icons/code-branch-dark.svg" width="18"></picture> Languages

**Full LSP + formatting:** TypeScript/React, Rust, Go, Lua, Python

**Supported:** HTML, CSS, Astro, SQL, Prisma, Bash, GLSL, TOML, YAML, JSON, Markdown

---

## <picture><source media="(prefers-color-scheme: dark)" srcset=".github/icons/keyboard-light.svg"><img src=".github/icons/keyboard-dark.svg" width="18"></picture> Keys

Leader is `<Space>`.

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>cf` | Format |
| `<leader>ca` | Code actions |
| `<leader>cr` | Rename |
| `gd` / `gr` | Definition / references |
| `<leader>gg` | Lazygit |
| `<leader>gb` | Git blame |
| `<M-c>` | Toggle Claude |
| `<M-o>` | Toggle OpenCode |
| `<leader>ap` | AI prompt |
| `<leader>l` | Lazy |
| `\|` / `\\` | Vertical / horizontal split |

---

## <picture><source media="(prefers-color-scheme: dark)" srcset=".github/icons/folder-tree-light.svg"><img src=".github/icons/folder-tree-dark.svg" width="18"></picture> Structure

```
lua/
  config/          keymaps, lsp, options
  daltonkyemiller/ colors, daily notes, utils
  plugins/         plugin configs
lsp/               per-server lsp configs
snippets/          custom snippets
after/queries/     treesitter injection queries
scripts/           helper scripts
```

---

## Setup

Requires Neovim >= 0.10, a [Nerd Font](https://www.nerdfonts.com/), ripgrep, and Node.js.

```bash
git clone https://github.com/daltonkyemiller/nvim ~/.config/nvim
nvim
```

Plugins install on first launch via [lazy.nvim](https://github.com/folke/lazy.nvim).

---

<sub>Icons by [Nucleo](https://nucleoapp.com) — &copy; Starter App S.R.L.</sub>
