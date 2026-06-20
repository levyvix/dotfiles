#!/bin/bash

status=$(omarchy-battery-status)

if [[ -r /var/lib/manual-power-mode/state ]]; then
  profile=$(< /var/lib/manual-power-mode/state)
else
  profile=$(powerprofilesctl get 2>/dev/null)
fi

if [[ $status =~ Battery[[:space:]]+([0-9]+)% ]]; then
  capacity=${BASH_REMATCH[1]}
else
  printf '%s\n' "$status"
  exit 0
fi

normalized=$(printf '%s\n' "$status" | sed -E 's/[[:space:]]+·[[:space:]]+/|/g; s/[[:space:]]+/ /g')
IFS='|' read -r _ time_left power_part <<< "$normalized"
time_left=${time_left% left}
time_left=${time_left% to full}
power=${power_part%%/*}

if (( capacity >= 95 )); then
  battery_icon="󰁹"
elif (( capacity >= 85 )); then
  battery_icon="󰂂"
elif (( capacity >= 75 )); then
  battery_icon="󰂁"
elif (( capacity >= 65 )); then
  battery_icon="󰂀"
elif (( capacity >= 55 )); then
  battery_icon="󰁿"
elif (( capacity >= 45 )); then
  battery_icon="󰁾"
elif (( capacity >= 35 )); then
  battery_icon="󰁽"
elif (( capacity >= 25 )); then
  battery_icon="󰁼"
elif (( capacity >= 15 )); then
  battery_icon="󰁻"
else
  battery_icon="󰁺"
fi

case "$profile" in
  power-saver) profile_gauge="[◉──]" ;;
  performance) profile_gauge="[──◉]" ;;
  *) profile_gauge="[─◉─]" ;;
esac

printf '%s %s%% · %s · %s · %s\n' "$battery_icon" "$capacity" "$time_left" "$power" "$profile_gauge"
