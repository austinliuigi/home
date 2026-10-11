#!/usr/bin/env bash

ACTIVE_WINDOW_WIDTH="$(hyprctl activewindow -j | jq '.size[0]')"
ACTIVE_MONITOR_WIDTH="$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .width')"

if [ -z "$ACTIVE_WINDOW_WIDTH" ] || [ "$ACTIVE_WINDOW_WIDTH" -eq 0 ]; then
    echo "No active window detected."
    exit 1
fi

# 4. Calculate 90% of the monitor width using bc (supports floating point)
threshold=$(echo "$ACTIVE_MONITOR_WIDTH * 0.90" | bc)

# 5. Compare the window width against the threshold
# bc returns 1 if true, 0 if false
if [ "$(echo "$ACTIVE_WINDOW_WIDTH > $threshold" | bc)" -eq 1 ]; then
    hyprctl dispatch 'hl.dsp.layout("expel")'
    hyprctl dispatch 'hl.dsp.layout("colresize 0.5")'
else
    hyprctl dispatch 'hl.dsp.layout("expel")'
    hyprctl dispatch 'hl.dsp.layout("colresize 1.0")'
fi
