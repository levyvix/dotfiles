#!/usr/bin/env bash

set -euo pipefail

current="$(powerprofilesctl get 2>/dev/null || echo balanced)"

if [[ "$current" == "power-saver" ]]; then
  next="balanced"
else
  next="power-saver"
fi

powerprofilesctl set "$next"

case "$next" in
  power-saver)
    icon="󰾆"
    label="Power saver"
    ;;
  balanced)
    icon="󰾅"
    label="Balanced"
    ;;
  *)
    icon="󰾅"
    label="$next"
    ;;
esac

notify-send -u low "$icon    Power mode set to $label"
pkill -SIGRTMIN+11 waybar || true
