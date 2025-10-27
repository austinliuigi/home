#!/usr/bin/env bash
#
# Remove the current workspace if it has no windows

N_WINS="$(hyprctl activeworkspace -j | jq '.windows')"

# don't do anything if workspace has windows
if [ $N_WINS -ne 0 ]; then
    exit 0
fi

ALL_WS_IDS_SORTED="$(hyprctl workspaces -j | jq 'sort_by(.id).[].id')"
CURRENT_WS_ID="$(hyprctl activeworkspace -j | jq '.id')"

# move each workspace down one (order matters)
for WS_ID in $ALL_WS_IDS_SORTED; do
    if [ "$WS_ID" -gt "$CURRENT_WS_ID" ]; then
        TARGET_WS_ID="$(($WS_ID - 1))"
        WS_WINDOWS=$(hyprctl clients -j | jq -r --arg id "$WS_ID" '.[] | select(.workspace.id == ($id | tonumber)) | .address')
        echo "$WS_WINDOWS" | xargs -I {} hyprctl dispatch movetoworkspacesilent "$TARGET_WS_ID",address:{}
    fi
done

# focus leftmost window
CURRENT_WS_LEFTMOST_WINDOW=$(hyprctl clients -j | jq -r --arg id "$CURRENT_WS_ID" '[.[] | select(.workspace.id == ($id | tonumber))] | min_by(.at[0]) | .address')
hyprctl dispatch focuswindow address:$CURRENT_WS_LEFTMOST_WINDOW
