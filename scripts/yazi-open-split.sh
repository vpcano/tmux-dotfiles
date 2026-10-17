#!/bin/sh
# Open a file from yazi in a tmux split (bound to <C-v> / <C--> in yazi's keymap.toml).
#
#   yazi-open-split.sh v <file>   vertical split   (panes side by side)
#   yazi-open-split.sh h <file>   horizontal split (panes stacked)
#
# Regular pane: splits the pane yazi runs in; yazi keeps running.
# tmux popup (YAZI_POPUP=1, see yazi-popup.sh): splits the pane the popup was
# opened from (YAZI_ORIGIN_PANE), then quits yazi so the popup closes.

mode=${1:-}
file=${2:-}
[ -n "$mode" ] && [ -n "$file" ] && [ -n "${TMUX:-}" ] || exit 0

case $mode in
  v) flag=-h ;; # vertical split:   new pane to the right
  h) flag=-v ;; # horizontal split: new pane below
  *) exit 1 ;;
esac

editor=${VISUAL:-${EDITOR:-nvim}}
if [ -d "$file" ]; then dir=$file; else dir=$(dirname "$file"); fi
qf=$(printf '%s' "$file" | sed "s/'/'\\\\''/g") # shell-escape for the pane command

# Inside a popup, split the pane the popup was opened from, never the popup window
if [ "${YAZI_POPUP:-}" = 1 ]; then
  target=${YAZI_ORIGIN_PANE:-}
else
  target=${TMUX_PANE:-}
fi
done=
if [ -n "$target" ]; then
  tmux split-window "$flag" -t "$target" -c "$dir" "$editor '$qf'" 2>/dev/null && done=1
fi
if [ -z "$done" ]; then
  [ "${YAZI_POPUP:-}" = 1 ] && exit 1
  tmux split-window "$flag" -c "$dir" "$editor '$qf'" || exit 1
fi

# Popup mode: close yazi (and with it the popup) now that the split exists
if [ "${YAZI_POPUP:-}" = 1 ] && [ -n "${YAZI_ID:-}" ]; then
  ya emit quit
fi
