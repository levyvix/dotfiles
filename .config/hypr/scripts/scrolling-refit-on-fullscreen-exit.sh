#!/bin/bash

# Realign the scrolling viewport when leaving fullscreen without resizing columns.

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

refocus_leftmost_then_current() {
  local ws_id current_addr left_addr window_count

  ws_id="$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id // empty')"
  current_addr="$(hyprctl activewindow -j 2>/dev/null | jq -r '.address // empty')"
  [[ -n "$ws_id" && -n "$current_addr" ]] || return

  window_count="$(hyprctl clients -j 2>/dev/null | jq --argjson ws "$ws_id" '[.[] | select(.workspace.id == $ws and .floating == false)] | length')"
  (( window_count > 1 )) || return

  left_addr="$(hyprctl clients -j 2>/dev/null | jq -r --argjson ws "$ws_id" '[.[] | select(.workspace.id == $ws and .floating == false)] | sort_by(.at[0]) | .[0].address // empty')"
  [[ -n "$left_addr" && "$left_addr" != "$current_addr" ]] || return

  hyprctl dispatch focuswindow "address:$left_addr"
  sleep 0.02
  hyprctl dispatch focuswindow "address:$current_addr"
}

socat -U - "UNIX-CONNECT:$SOCKET" | while read -r event; do
  case "$event" in
    fullscreen\>\>*)
      state="${event##*,}"
      if [[ "$state" != "0" ]]; then
        continue
      fi

      layout="$(hyprctl getoption general:layout -j 2>/dev/null | jq -r '.str // empty')"
      if [[ "$layout" != "scrolling" ]]; then
        continue
      fi

      sleep 0.05
      hyprctl dispatch layoutmsg center
      refocus_leftmost_then_current
      ;;
  esac
done
