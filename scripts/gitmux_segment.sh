#!/bin/sh
# gitmux segment for status-right: catppuccin-styled, but only inside a git repo.
out=$(gitmux -cfg "$HOME/.gitmux.conf" "$1" 2>/dev/null)
[ -n "$out" ] || exit 0
printf '%s%s%s' '#[fg=#94e2d5]#[fg=#11111b,bg=#94e2d5]󰊢 #[fg=#cdd6f4,bg=#313244]' "$out" '#[fg=#313244] '
