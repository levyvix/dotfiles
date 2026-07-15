#!/usr/bin/env bash

set -euo pipefail

current="$(powerprofilesctl get 2>/dev/null || echo balanced)"

if [[ "$current" == "power-saver" ]]; then
  next="balanced"
else
  next="power-saver"
fi

# ThinkPad DYTC (lapmode) faz o EC reverter platform_profile=low-power para
# balanced em ~50ms, e o power-profiles-daemon segue o firmware. Recarregar o
# thinkpad_acpi reseta o estado DYTC para que o low-power seja aceito e segure.
if [[ "$next" == "power-saver" ]]; then
  sudo -n /usr/local/bin/reload-thinkpad-acpi || true
  sleep 1
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
