#!/usr/bin/env bash

if [ "$#" -eq 0 ]
then
    # list out choices
    echo "poweroff"
    echo "restart"
    echo "suspend"
    echo "lock"
    exit 0
fi

# handle selected choice
case "$1" in
    "poweroff") poweroff ;;
    "reboot") reboot ;;
    "suspend") systemctl suspend ;;
    "lock") loginctl lock-session ;;
esac
