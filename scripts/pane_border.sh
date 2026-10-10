#!/bin/sh
# pane_border.sh <pane_current_command> <pane_pid>
# Pane title bar content: catppuccin-styled command segment; empty output
# (bare border line) when the pane is just a shell.
case $1 in
  zsh|bash|fish|'') exit 0 ;;
esac
name=$("$HOME/.config/tmux/scripts/pane_cmd.sh" "$1" "$2")
[ -n "$name" ] || exit 0
printf '#[fg=#a6e3a1,bg=default]█#[fg=#a6e3a1,bg=#313244] %s #[fg=#313244,bg=default]█' "$name"
