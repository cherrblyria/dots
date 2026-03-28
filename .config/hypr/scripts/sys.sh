#!/usr/bin/env bash

pkill rofi || true

case "$(printf "kill\nkillall\nlock\nzzz\nreboot\nshutdown" | rofi -dmenu -theme-str 'listview { lines: 6; } window { width: 16%; }' -p "system")" in
kill)
  ps -u "$USER" -o pid,comm,%cpu,%mem |
    rofi -dmenu -theme-str "window { width: 23%;}" -p "kill" |
    awk '{print $1}' |
    xargs -r kill
  ;;
killall)
  ps -u "$USER" -o pid,comm,%cpu,%mem |
    rofi -dmenu -theme-str "window { width: 23%;}" -p "killall" |
    awk '{print $2}' |
    xargs -r pkill
  ;;
lock)
  pidof hyprlock || hyprlock
  ;;
zzz)
  systemctl suspend
  ;;
reboot)
  systemctl reboot
  ;;
shutdown)
  shutdown now
  ;;
esac
