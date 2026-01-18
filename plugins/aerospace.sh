#!/bin/bash
# Usage: aerospace.sh <workspace_id>

WORKSPACE_ID="$1"

# Get the focused workspace from the environment (set by sketchybar trigger)
FOCUSED_WORKSPACE="$FOCUSED_WORKSPACE"

# Debug log
LOGFILE="$HOME/.sketchybar_aerospace_debug.log"
echo "$(date) WORKSPACE_ID=$WORKSPACE_ID FOCUSED_WORKSPACE=$FOCUSED_WORKSPACE" >> "$LOGFILE"

# Default colors
BORDER_COLOR=0x00000000
BORDER_WIDTH=1
BG_COLOR=0x40ffffff
LABEL_COLOR=0xffffffff
ICONS=""
ICON_COLOR=0xffffffff

# If this workspace is focused, highlight it
if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
  BORDER_COLOR=0xffFF747F  # off deep purple
  BORDER_WIDTH=1
  LABEL_COLOR=0xffFF747F   # black text
  ICON_COLOR=0xffFF747F  # off deep purple
  BG_COLOR=0xffECDCE1
fi

# Map app names to Nerd Font icons
map_app_to_icon() {
  case "$1" in
    "Safari") echo "󰀹";; # globe
    "Google Chrome") echo "";;
    "Firefox") echo "";;
    "Brave"|"Brave Browser") echo "󰣩";;
    "Terminal"|"iTerm2"|"Warp") echo "";;
    "Code"|"Visual Studio Code") echo "󰨞";;
    "Slack") echo "";;
    "Spotify") echo "";;
    "Finder") echo "󰀶";;
    "Notes") echo "";;
    "Mail") echo "";;
    "Messages") echo "";;
    "Preview") echo "";;
    "WhatsApp" | "WhatsApp Desktop" | "Whatsapp") echo "";;
    "Notion") echo "";; # or use another suitable icon
    *) echo "";; # better default: filled circle
  esac
}

# Get all unique app names in the workspace and map to icons
APPS=$(aerospace list-windows --workspace "$WORKSPACE_ID" --format "%{app-name}" | sort | uniq)
ICONS=""
ICON_SET=""
for app in $APPS; do
  # Normalize app name: trim, lower case
  norm_app=$(echo "$app" | awk '{$1=$1;print}' | tr '[:upper:]' '[:lower:]')
  icon=""
  case "$norm_app" in
    *brave*) icon="󰣩";;
    *whatsapp*) icon="";;
    safari) icon="󰀹";;
    google\ chrome) icon="";;
    firefox) icon="";;
    terminal|iterm2|warp) icon="";;
    code|visual\ studio\ code) icon="󰨞";;
    slack) icon="";;
    spotify) icon="";;
    finder) icon="󰀶";;
    notes) icon="";;
    mail) icon="";;
    messages) icon="";;
    preview) icon="";;
    notion) icon="";;
    *) icon="";; # skip default icon for unmatched/empty
  esac
  # Only add unique, non-empty icons
  if [ -n "$icon" ] && [[ "$ICON_SET" != *"$icon"* ]]; then
    ICONS+="$icon "
    ICON_SET+="$icon "
  fi
  unset icon
  unset norm_app
  unset app

done
ICONS=$(echo "$ICONS" | sed 's/ *$//')

sketchybar --set space.$WORKSPACE_ID \
  background.border_color=$BORDER_COLOR \
  background.border_width=$BORDER_WIDTH \
  background.color=$BG_COLOR \
  label.color=$LABEL_COLOR \
  label.align=center \
  icon.color=$ICON_COLOR \
  icon="$ICONS"
