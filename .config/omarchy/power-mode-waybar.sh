#!/usr/bin/env bash

set -euo pipefail

state="$(manual-power-mode get 2>/dev/null || cat /var/lib/manual-power-mode/state 2>/dev/null || echo balanced)"

case "$state" in
  power-saver)
    icon="󰾆"
    ;;
  balanced)
    icon="󰗑"
    ;;
  performance)
    icon="󱐋"
    ;;
  *)
    icon="󰗑"
    state="balanced"
    ;;
esac

jq -cn --arg text "$icon" --arg class "$state" --arg tooltip "Power mode: $state" \
  '{text:$text,class:$class,tooltip:$tooltip}'
