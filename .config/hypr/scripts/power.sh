#!/usr/bin/env bash

# shellcheck source=/home/nutty/.config/hypr/_config.sh
source "$HOME"/.config/hypr/_config.sh

pkill rofi || true

case "$(rofi_menu "system" "" "zzz" "lockout" "reboot" "shutdown")" in
zzz)
  systemctl suspend
  ;;
lockout)
  "$SCRIPT_DIR"/exit.sh
  ;;
reboot)
  systemctl reboot
  ;;
shutdown)
  shutdown now
  ;;
esac
