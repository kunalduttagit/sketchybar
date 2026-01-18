#!/bin/sh

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

# Map app names to Nerd Font icons (same as aerospace.sh)
map_app_to_icon() {
  case "$1" in
    "Safari") echo "󰀹";;
    "Google Chrome") echo "";;
    "Firefox") echo "";;
    "Brave") echo "󰣩";;
    "Terminal"|"iTerm2"|"Warp") echo "";;
    "Code"|"Visual Studio Code") echo "󰨞";;
    "Slack") echo "";;
    "Spotify") echo "";;
    "Finder") echo "󰀶";;
    "Notes") echo "";;
    "Mail") echo "";;
    "Messages") echo "";;
    "Preview") echo "";;
    "Notion") echo "";;
    *) echo "";;
  esac
}

if [ "$SENDER" = "front_app_switched" ]; then
  ICON=$(map_app_to_icon "$INFO")
  sketchybar --set front_app_icon icon="$ICON"
  sketchybar --set front_app label="$INFO"
fi
