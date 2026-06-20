#!/usr/bin/env bash

set -euo pipefail

current="$(manual-power-mode get 2>/dev/null || echo balanced)"

case "$current" in
  power-saver)
    next="balanced"
    ;;
  balanced)
    next="performance"
    ;;
  performance)
    next="power-saver"
    ;;
  *)
    next="balanced"
    ;;
esac

sudo manual-power-mode "$next"
pkill -SIGRTMIN+11 waybar || true
