#!/usr/bin/env bash

# https://dev.to/meleu/how-to-join-array-elements-in-a-bash-script-303a
join() {
  local sep="$1"
  shift
  local str="$1"
  shift
  printf "%s" "$str" "${@/#/$sep}"
  echo
}

# available modes
modes=(
"drun"
"run"
"wifi"
"power"
"ssh"
"window"
)

# selected mode
mode="$(echo -e "$(join "\n" "${modes[@]}")" | rofi -dmenu)"

# early exit
if [ -z $mode ]; then
    exit 0
fi

# set script if a selected mode is a script mode
case "$mode" in
    # bulitin modes
    "drun")
        ;&
    "run")
        ;&
    "ssh")
        ;&
    "window")
        rofi -show "$mode"
        ;;

    # rofi script modes
    "power")
        script="${script:-${HOME}/.local/share/rofi/scripts/power.sh}"
        rofi -show "$mode" -modes "${mode}:${script}"
        ;;

    # rofi dmenu scripts
    "wifi")
        eval "${HOME}/.local/share/rofi/scripts/wifi/default.sh"
esac
