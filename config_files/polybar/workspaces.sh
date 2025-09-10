#!/usr/bin/env bash

# Main fixed workspaces 
# If you have one Monitor and want to stick Nuke 󰚤 icon to the end, Just add like workspace 8 in and change it icon below
workspaces=(1 2 3 4 5 6 7)

# Icons/labels
declare -A icons=(
  [1]="S ."
  [2]="P ."
  [3]="E ."
  [4]="C ."
  [5]="I ."
  [6]="A ."
  [7]="L ."
  [8]="8"
  [9]="9"
  [10]="10"
  [11]="󰚤"
  [12]="12"
  [13]="13"
  [14]="14"
  [15]="15"
  [16]="16"
  [17]="17"
  [18]="18"
  [19]="19"
  [20]="20"
)

print_workspaces() {
    # Current focused workspace
    current=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

    # All active workspaces
    mapfile -t active_ws < <(i3-msg -t get_workspaces | jq -r '.[].name')

    # Always show 1–7
    for ws in "${workspaces[@]}"; do
        icon=${icons[$ws]}
        if [[ "$ws" == "$current" ]]; then
            echo -n "%{A1:sh -c 'i3-msg workspace $ws':}%{F#FFB642}[$icon]%{F-}%{A} "
        else
            echo -n "%{A1:sh -c 'i3-msg workspace $ws':}$icon%{A} "
        fi
    done

    # Show any overflow (>=8) dynamically
    for ws in "${active_ws[@]}"; do
	icon=${icons[$ws]}
        if [[ ! " ${workspaces[*]} " =~ " $ws " ]]; then
            if [[ "$ws" == "$current" ]]; then
                echo -n "%{A1:sh -c 'i3-msg workspace $ws':}%{F#FFB642}[ $icon ]%{F-}%{A} "
            else
                echo -n "%{A1:sh -c 'i3-msg workspace $ws':}$icon%{A} "
            fi
        fi
    done

    echo
}

# Print once at start
print_workspaces

# Subscribe to i3 events for instant updates
i3-msg -t subscribe '[ "workspace" ]' | while read -r _; do
    print_workspaces
done
