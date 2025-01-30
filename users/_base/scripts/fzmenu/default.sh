#!/usr/bin/env bash

modes="\
apps
wifi
power\
"

mode="$(echo -e "$modes" | fzf --no-clear)"
if [ -z $mode ]; then
    exit 0
fi

case "$mode" in
    "apps")
        j4_log_dir="${HOME}/.local/state/j4-dmenu-desktop"
        mkdir -p "$j4_log_dir"
        app="$(j4-dmenu-desktop --dmenu=fzf --no-generic --no-exec --usage-log="${j4_log_dir}/j4-dmenu-desktop.log")"
        [[ -z "$app" ]] || eval "nohup $app >/dev/null &"
        sleep 0.000001 # required to give time for selected application to start
        ;;
    "wifi")
        eval "${HOME}/scripts/fzmenu/wifi/default.sh"
        ;;
    "power")
        eval "${HOME}/scripts/fzmenu/power.sh"
        ;;
esac
