#!/bin/bash

if [[ -r /var/lib/manual-power-mode/state ]]; then
  profile=$(< /var/lib/manual-power-mode/state)
else
  profile=$(powerprofilesctl get 2>/dev/null || printf 'balanced')
fi

case "$profile" in
  power-saver)
    icon="󰾆"
    text="power-saver"
    ;;
  performance)
    icon="󰓅"
    text="performance"
    ;;
  *)
    icon="󰾅"
    text="balanced"
    ;;
esac

printf '{"text":"%s","class":"%s","tooltip":"Power mode: %s"}\n' "$icon" "$profile" "$text"
