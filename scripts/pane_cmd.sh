#!/bin/sh
# pane_cmd.sh <pane_current_command> <pane_pid>
# Friendly foreground-command name for window tabs: unwraps interpreter
# processes (node/bun) so e.g. "pi" shows instead of "node".
cmd=$1
pid=$2
case $cmd in
  node|bun) ;;
  *) printf '%s' "$cmd"; exit 0 ;;
esac
child=$(pgrep -P "$pid" 2>/dev/null | head -n 1)
[ -n "$child" ] || { printf '%s' "$cmd"; exit 0; }
ccomm=$(ps -o comm= -p "$child" 2>/dev/null)
ccomm=${ccomm##*/}
case $ccomm in
  ""|node|bun)
    # plain interpreter: use the script it runs
    args=$(ps -o args= -p "$child" 2>/dev/null)
    set -f; set -- $args; set +f
    while [ $# -gt 0 ]; do
      case $1 in
        -*|node|bun|*/node|*/bun) shift ;;
        *) name=${1##*/}; name=${name%.js}; name=${name%.mjs}
           printf '%s' "$name"; exit 0 ;;
      esac
    done
    printf '%s' "$cmd" ;;
  *)
    printf '%s' "$ccomm" ;;
esac
