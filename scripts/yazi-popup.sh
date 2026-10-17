#!/bin/sh
# yazi file chooser in a tmux popup (bound to prefix + C-y in tmux.conf).
#
#   Enter   -> open the selected file(s) with $EDITOR in a new tmux window
#   <C-v>   -> open the hovered file in a vertical split
#   <C-->   -> open the hovered file in a horizontal split
#
# Every action closes the popup: Enter makes yazi (--chooser-file) quit after
# writing the selection, and the split keys are handled by yazi-open-split.sh,
# which quits yazi once the split exists. tmux closes the popup (-E) as soon
# as this script exits.

# YAZI_ORIGIN_PANE = pane the popup was opened from (set via display-popup -e);
# used as the target for the split keys
case ${YAZI_ORIGIN_PANE:-} in
  %[0-9]*) export YAZI_ORIGIN_PANE ;;
  *) unset YAZI_ORIGIN_PANE ;;
esac
export YAZI_POPUP=1

choice=${TMPDIR:-/tmp}/yazi-popup-$$
trap 'rm -f "$choice"' EXIT HUP INT TERM

yazi --chooser-file="$choice"

# Closed without choosing -> just close the popup
[ -s "$choice" ] || exit 0

editor=${VISUAL:-${EDITOR:-nvim}}
cmd=$editor
first=
while IFS= read -r f; do
  [ -n "$f" ] || continue
  [ -n "$first" ] || first=$f
  qf=$(printf '%s' "$f" | sed "s/'/'\\\\''/g") # shell-escape for the pane command
  cmd="$cmd '$qf'"
done < "$choice"
[ -n "$first" ] || exit 0

if [ -d "$first" ]; then dir=$first; else dir=$(dirname "$first"); fi
tmux new-window -c "$dir" "$cmd"
