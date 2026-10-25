#!/bin/bash

# Function to check if the current workspace is empty
check_workspace() {
    # Count how many window containers exist on the currently focused workspace
    local count=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true) | .num')
    local windows=$(swaymsg -t get_tree | jq --argjson num "$count" '.. | select(.type? == "workspace" and .num? == $num) | .focus | length')

    if [ "$windows" -eq 0 ]; then
        # Workspace empty -> Show the bar
        noctalia msg bar-set-visible default true
    else
        # Workspace has windows -> Hide the bar
        noctalia msg bar-set-visible default false
    fi
}

# Run once at startup
check_workspace

# Continuously monitor Sway for window and workspace changes
swaymsg -t subscribe '["window", "workspace"]' --monitor | while read -r event; do
    check_workspace
done
