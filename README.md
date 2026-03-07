# nvim

My Neovim config. Built around TypeScript/React but handles most things I throw at it.

---

### <picture><source media="(prefers-color-scheme: dark)" srcset=".github/icons/sparkle-light.svg"><img src=".github/icons/sparkle-dark.svg" width="24" align="top"></picture> AI

- [sidekick.nvim](https://github.com/folke/sidekick.nvim) — Claude, OpenCode, Gemini, Copilot, Codex, Grok, and more in a split with tmux persistence
- [ninetyfive](https://github.com/ninetyfive-gg/ninetyfive.nvim) — inline completions

### <picture><source media="(prefers-color-scheme: dark)" srcset=".github/icons/code-editor-light.svg"><img src=".github/icons/code-editor-dark.svg" width="24" align="top"></picture> Editor

- [blink.cmp](https://github.com/Saghen/blink.cmp) — completion engine
- LSP via Mason — vtsls, rust-analyzer, gopls, lua_ls, pyright, tailwindcss, biome, emmet, and more
- [conform.nvim](https://github.com/stevearc/conform.nvim) — formatting with smart JS/TS formatter selection (oxfmt > biome > prettierd)
- Treesitter with custom text objects, injection queries, and [flash.nvim](https://github.com/folke/flash.nvim) motions
- [multicursor.nvim](https://github.com/jake-stewart/multicursor.nvim) — multiple cursors
- [nvim-surround](https://github.com/kylechui/nvim-surround) — surround text objects

### <picture><source media="(prefers-color-scheme: dark)" srcset=".github/icons/color-palette-light.svg"><img src=".github/icons/color-palette-dark.svg" width="24" align="top"></picture> UI

- [miasma](https://github.com/xero/miasma.nvim) palette via [mini.base16](https://github.com/echasnovski/mini.base16) — earthy, muted color scheme with custom highlight overrides
- [snacks.nvim](https://github.com/folke/snacks.nvim) — picker, file explorer, notifications, terminal, lazygit
- [lualine](https://github.com/nvim-lualine/lualine.nvim) — status line
- [noice.nvim](https://github.com/folke/noice.nvim) — command line and message UI

### <picture><source media="(prefers-color-scheme: dark)" srcset=".github/icons/wrench-light.svg"><img src=".github/icons/wrench-dark.svg" width="24" align="top"></picture> Tools

- [gitsigns](https://github.com/lewis6991/gitsigns.nvim) + lazygit + [diffview](https://github.com/sindrets/diffview.nvim) + [git-blame](https://github.com/f-person/git-blame.nvim)
- [harpoon](https://github.com/ThePrimeagen/harpoon) — quick file marks
- [persistence.nvim](https://github.com/folke/persistence.nvim) — session persistence
- [trouble.nvim](https://github.com/folke/trouble.nvim) — diagnostics list
- [dbee](https://github.com/kndndrj/nvim-dbee) — database explorer
- [kulala](https://github.com/mistweaverco/kulala.nvim) — HTTP client
- Lazydocker, [cord.nvim](https://github.com/vyfor/cord.nvim) (Discord presence)

---

## <picture><source media="(prefers-color-scheme: dark)" srcset=".github/icons/code-branch-light.svg"><img src=".github/icons/code-branch-dark.svg" width="24" align="top"></picture> Languages

**Full LSP + formatting:** TypeScript/React, Rust, Go, Lua, Python, CSS/SCSS, HTML

**Additional LSP:** Astro, Tailwind CSS, Prisma, SQL (postgres_ls), Docker/Compose, Bash, GLSL, QML, Ansible, JSON, YAML, TOML, Jinja, Emmet

**Formatters:** oxfmt, biome, prettierd, stylua, rustfmt, gofmt, black, isort, shfmt, pg_format, clang_format, djlint, tombi

---

## <picture><source media="(prefers-color-scheme: dark)" srcset=".github/icons/command-light.svg"><img src=".github/icons/command-dark.svg" width="24" align="top"></picture> Keys

Leader is `<Space>`.

**Find**

| Key | Action |
|-----|--------|
| `<leader><space>` | Smart find files |
| `<leader>ff` | Find files |
| `<leader>/` | Grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Resume last search |
| `<leader>fh` | File history |
| `<leader>fs` | Workspace symbols |
| `<leader>e` | File explorer |

**Code**

| Key | Action |
|-----|--------|
| `<leader>cf` | Format |
| `gd` / `gr` | Definition / references |
| `<leader>q` | Diagnostics list |

**Git**

| Key | Action |
|-----|--------|
| `<leader>gg` | Lazygit |
| `<leader>hb` | Blame line |
| `<leader>hp` | Preview hunk |
| `<leader>hs` / `<leader>hr` | Stage / reset hunk |
| `]c` / `[c` | Next / prev hunk |
| `<leader>gbb` | Browse branch |

**AI (sidekick)**

| Key | Action |
|-----|--------|
| `<M-c>` | Toggle Claude |
| `<M-o>` | Toggle OpenCode |
| `<leader>ap` | Prompt |
| `<leader>as` | Select CLI tool |
| `<leader>ac` | Switch Claude session |
| `@` | File picker (in sidekick terminal) |

**Other**

| Key | Action |
|-----|--------|
| `<leader>hh` / `<leader>ha` | Harpoon menu / add |
| `<M-t>` | Terminal |
| `<leader>dd` | Lazydocker |
| `<leader>l` | Lazy |
| `\|` / `\\` | Vertical / horizontal split |

---

## <picture><source media="(prefers-color-scheme: dark)" srcset=".github/icons/folder-tree-light.svg"><img src=".github/icons/folder-tree-dark.svg" width="24" align="top"></picture> Structure

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

<sub>Icons: Copyright &copy; Nucleo. [Nucleo Icons](https://nucleoapp.com/) — Redistribution of icons is prohibited. Icons are restricted for use only within the product they are bundled with. [License](https://nucleoapp.com/license).</sub>
