#!/usr/bin/env bash

modes="\
 Lock
󰅟 Suspend
󰤄 Hibernate
󰜉 Reboot
󰐥 Poweroff\
"

mode="$(echo -e "$modes" | fuzzel --dmenu)"
if [ -z $mode ]; then
    exit 0
fi

case "$mode" in
    *Lock*) loginctl lock-session ;;
    *Suspend*) systemctl suspend ;;
    *Reboot*) reboot ;;
    *Hibernate*) systemctl hibernate ;;
    *Poweroff*) poweroff ;;
esac
