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
"run"
"drun"
"ssh"
"window"
"power"
)

# selected mode
mode="$(echo -e "$(join "\n" "${modes[@]}")" | rofi -dmenu)"

# set script if a selected mode is a script mode
case "$mode" in
    "power") script="${HOME}/.local/share/rofi/scripts/power.sh" ;;
esac

# run rofi on selected mode
if [ -n "$script" ]
then
    rofi -show "$mode" -modes "${mode}:${script}"
else
    rofi -show "$mode"
fi
