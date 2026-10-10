# tmux config

Minimal tmux setup: Catppuccin Mocha status bar, vi-style navigation, and
seamless nvim/tmux pane movement via smart-splits.

- `tmux.conf` — main config (theme, bindings, QoL defaults)
- `plugins/catppuccin/tmux` — theme submodule (`git submodule update --init`)
- `scripts/` — status line helpers: friendly command names, pane title bars,
  git segment (needs [gitmux](https://github.com/arl/gitmux))

Requires a Nerd Font; optimized for kitty with truecolor + undercurls.
`prefix + r` reloads the config.
