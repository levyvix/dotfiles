#!/usr/bin/env bash

set -euo pipefail

TOGGLE_CONF="$HOME/.local/state/omarchy/toggles/hypr/scrolling-full-width.conf"

layout="$(hyprctl getoption general:layout -j 2>/dev/null | jq -r '.str // empty')"
if [[ "$layout" != "scrolling" ]]; then
  notify-send -u low "󰖯    Scrolling center toggle" "Active workspace is not using the scrolling layout."
  exit 0
fi

enable_full_width() {
  mkdir -p "$(dirname "$TOGGLE_CONF")"
  cat >"$TOGGLE_CONF" <<'EOF'
scrolling {
    fullscreen_on_one_column = true
    focus_fit_method = 1
}
EOF
  hyprctl keyword scrolling:fullscreen_on_one_column true
  hyprctl keyword scrolling:focus_fit_method 1
  notify-send -u low "󰖯    Scrolling: full width"
}

enable_centered() {
  rm -f "$TOGGLE_CONF"
  hyprctl keyword scrolling:fullscreen_on_one_column false
  hyprctl keyword scrolling:focus_fit_method 0
  hyprctl keyword scrolling:column_width 0.5
  notify-send -u low "󰖯    Scrolling: centered"
}

if [[ -f "$TOGGLE_CONF" ]]; then
  enable_centered
else
  enable_full_width
fi

hyprctl dispatch layoutmsg center
