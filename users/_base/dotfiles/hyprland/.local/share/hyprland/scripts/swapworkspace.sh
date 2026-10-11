#!/usr/bin/env bash

# Swaps the active workspace with another workspace
# $1 => the workspace param of the target workspace

# early exit
if [ $# -ne 1 ]; then
  echo "Usage: $0 <workspace_param>"
  exit 1
fi

TEMP_WS_ID="99"

# TODO if current animation is enabled, store it and disable it

# get current workspace id
CURRENT_WS_ID="$(hyprctl activeworkspace -j | jq '.id')"
# get target workspace id based on cli arg
hyprctl dispatch "hl.dsp.focus({workspace = '$1'})"  # switch to target workspace
TARGET_WS_ID="$(hyprctl activeworkspace -j | jq '.id')"

# if didn't switch workspaces
if [ "$TARGET_WS_ID" == "$CURRENT_WS_ID" ]; then
  echo "Invalid workspace parameter"
  exit 1
fi

hyprctl dispatch "hl.dsp.focus({workspace = '$TEMP_WS_ID'})"  # switch to temp workspace to avoid screen anims


# get all windows in current workspace
CURRENT_WS_WINDOWS=$(hyprctl clients -j | jq -r --arg id "$CURRENT_WS_ID" '.[] | select(.workspace.id == ($id | tonumber)) | .address')
# get all windows in target workspace
TARGET_WS_WINDOWS=$(hyprctl clients -j | jq -r --arg id "$TARGET_WS_ID" '.[] | select(.workspace.id == ($id | tonumber)) | .address')



# move all windows initially from target workspace to current workspace
echo "$TARGET_WS_WINDOWS" | xargs -I {} hyprctl dispatch "hl.dsp.window.move({ workspace = '$CURRENT_WS_ID', follow = false, window = 'address:{}'})"
# move all windows from current workspace to target workspace
echo "$CURRENT_WS_WINDOWS" | xargs -I {} hyprctl dispatch "hl.dsp.window.move({ workspace = '$TARGET_WS_ID', follow = false, window = 'address:{}'})"


hyprctl dispatch "hl.dsp.focus({workspace = '$TARGET_WS_ID'})"


# TODO reset previous animation enabled
