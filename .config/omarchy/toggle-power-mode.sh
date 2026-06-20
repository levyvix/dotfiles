#!/bin/bash

current=$(sudo /usr/local/bin/manual-power-mode get)

if [[ $current == "power-saver" ]]; then
  next=balanced
else
  next=power-saver
fi

sudo /usr/local/bin/manual-power-mode "$next"
pkill -SIGRTMIN+11 waybar

case $next in
  power-saver)
    notify-send -u low "Power Mode" "power-saver"
    ;;
  balanced)
    notify-send -u low "Power Mode" "balanced"
    ;;
esac
