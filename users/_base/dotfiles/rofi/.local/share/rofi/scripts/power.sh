#!/usr/bin/env bash

if [ "$#" -eq 0 ]
then
    # list out choices
    echo "poweroff"
    echo "restart"
    echo "lock"
    exit 0
fi

# handle selected choice
case "$1" in
    "poweroff") poweroff ;;
    "restart") reboot ;;
    "lock") loginctl lock-session ;;
esac
