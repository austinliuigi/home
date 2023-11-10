# Swaps the active monitor with another monitor
# $1 => the monitor param of the target monitor

# early exit
if [ $# -ne 1 ]; then
  echo "Usage: $0 <monitor_param>"
  exit 1
fi



# get current monitor id
CURRENT_MON_NAME="$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')"
CURRENT_MON_ACTIVEWIN_ADDR="$(hyprctl activewindow -j | jq -r .address)"

# get target monitor id based on cli arg
hyprctl dispatch focusmonitor "$1"  # switch to target monitor
TARGET_MON_NAME="$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')"
TARGET_MON_ACTIVEWIN_ADDR="$(hyprctl activewindow -j | jq -r .address)"

# if didn't switch monitors
if [ "$TARGET_MON_NAME" == "$CURRENT_MON_NAME" ]; then
  echo "Invalid monitor parameter"
  exit 1
fi



# save all workspaces in current monitor
CURRENT_MON_WORKSPACES=$(hyprctl workspaces -j | jq -r --arg name "$CURRENT_MON_NAME" '.[] | select(.monitor == $name) | .id')

# save all windows in target workspace
TARGET_MON_WORKSPACES=$(hyprctl workspaces -j | jq -r --arg name "$TARGET_MON_NAME" '.[] | select(.monitor == $name) | .id')



# move all windows from current workspace to target workspace
echo "$CURRENT_MON_WORKSPACES" | xargs -I {} hyprctl dispatch moveworkspacetomonitor {} "$TARGET_MON_NAME"

# move all windows initially from target workspace to current workspace
echo "$TARGET_MON_WORKSPACES" | xargs -I {} hyprctl dispatch moveworkspacetomonitor {} "$CURRENT_MON_NAME"



# restore which windows were focused
hyprctl dispatch focuswindow address:${TARGET_MON_ACTIVEWIN_ADDR}
hyprctl dispatch focuswindow address:${CURRENT_MON_ACTIVEWIN_ADDR}
