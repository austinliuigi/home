#!/usr/bin/env bash


iter=${ROFI_DATA:-0}
echo -e "\0data\x1f$((iter+1))" # increment iter for next iteration



# ITERATION 0
if [ "$iter" -eq 0 ]; then

echo -e "\0prompt\x1fnetwork"

iwctl station wlan0 scan

# list out choices
iwctl_output="$(iwctl station wlan0 get-networks \
| tail -n +5 \
| sed -e "s:\[1;30m::g" \
      -e "s:\[0m::g" \
      -e "s:\*\x1b.*:\*:g" \
      -e "s:\x1b::g" \
      -e "s:\[1;90m>::g")"

ifs_original="$IFS"
IFS=$'\n'
for line in $iwctl_output; do
    strength="$(echo "$line" | awk '{print $NF}' | grep -o "*" | wc -l)"
    security="$(echo "$line" | awk '{print $(NF-1)}')"
    network="$(echo "$line" | awk '{for (c=1; c<=NF-3; c++) printf "%s ", $c; printf "%s", $(NF-2)}')"

    echo -n "$network"

    if [ "$security" = "open" ]; then
        echo -e "\0icon\x1f<span color='white'></span>"
        # echo -e "\0display\x1f${network} "
    else
        echo -e "\0icon\x1f<span color='white'></span>"
        # echo -e "\0display\x1f${network} "
    fi
done
IFS="$ifs_original"

exit 0

fi



# ITERATION 1
if [ "$iter" -eq 1 ]; then

function exit_if_error() {
    if [ "$?" == 1 ]; then
        echo "$1"
        exit
    fi
}

network="$1"
exit_if_error "cancelled"

# TODO: also check for public networks
if [ "$(iwctl known-networks list | grep -c "$network")" -gt 0 ]; then
    iwctl station wlan0 connect "$network"
else
    # get password for next iteration
    echo -e "\0prompt\x1fpassphrase for network \"${network}\""
    echo -e " \0nonselectable\x1ftrue" # dummy entry
fi

fi



# FIX: persist network variable from prev iteration
# ITERATION 2
if [ "$iter" -eq 2 ]; then
    iwctl station wlan0 connect "$network" --passphrase "$1" > /dev/null
    echo "$network"
    # notify-send result
fi
