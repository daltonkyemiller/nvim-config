# tmux picker context

Neovim writes lightweight file context for the tmux `@` picker.

## Where it writes

```text
~/.local/state/agent-mux/nvim-context/<cwd-sha256-prefix>.json
```

One file per cwd.

## What it writes

- `cwd`
- `tmux_pane`
- `updated_at`
- `current_file`
- `alternate_file`
- `open_buffers`
- `recent_files`

All file paths are normalized to absolute paths, then filtered to the current cwd.

## Triggers

Context updates on:

- `VimEnter`
- `BufEnter`
- `WinEnter`
- `BufWritePost`
- `DirChanged`

Writes are debounced so rapid window/buffer transitions do not spam disk writes.
