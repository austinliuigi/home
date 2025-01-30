#!/usr/bin/env bash

modes="\
lock
suspend
reboot
hibernate
poweroff\
"

mode="$(echo -e "$modes" | fzf)"
if [ -z $mode ]; then
    exit 0
fi

case "$mode" in
    "lock") loginctl lock-session ;;
    "suspend") systemctl suspend ;;
    "reboot") reboot ;;
    "hibernate") systemctl hibernate ;;
    "poweroff") poweroff ;;
esac
