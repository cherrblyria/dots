#!/usr/bin/env bash

# shellcheck source=/home/nutty/.config/hypr/_config.sh
source "$HOME"/.config/hypr/_config.sh

pkill rofi || true

case $(rofi_menu "menu" "" "apps" "clipboard" "emoji" "run" "music" "settings" "system") in
apps)
  eval "$DRUN"
  ;;
clipboard)
  eval "$CLIP"
  ;;
emoji)
  eval "$EMOJI"
  ;;
run)
  eval "$RUN"
  ;;
music)
  case $(rofi_menu "music" "" "next" "play/pause" "previous") in
  next)
    "$SCRIPT_DIR"/music.sh next
    ;;
  play/pause)
    "$SCRIPT_DIR"/music.sh playpause
    ;;
  previous)
    "$SCRIPT_DIR"/music.sh previous
    ;;
  esac
  ;;
settings)
  case $(rofi_menu "settings" "" "wallpaper" "audio" "bluetooth" "network") in
  wallpaper)
    case $(rofi_menu "wallpaper" "" "change" "random") in
    change)
      $OT "$SCRIPT_DIR"/wallpaper.sh
      ;;
    random)
      "$SCRIPT_DIR"/wallpaper.sh random
      ;;
    esac
    ;;
  audio)
    $OT pulsemixer
    ;;
  bluetooth)
    $OT bluetui
    ;;
  network)
    $OT nmtui
    ;;
  esac
  ;;
system)
  case $(rofi_menu "system" "" "kill" "killall" "lock" "reload" "power") in
  kill)
    ps -u "$USER" -o pid,comm |
      rofi -dmenu -theme-str "$(rofi_theme)" -p "kill" |
      awk '{print $1}' |
      xargs -r kill
    ;;
  killall)
    ps -u "$USER" -o pid,comm |
      rofi -dmenu -theme-str "$(rofi_theme)" -p "killall" |
      awk '{print $2}' |
      xargs -r pkill
    ;;
  lock)
    pidof hyprlock || hyprlock
    ;;
  reload)
    "$SCRIPT_DIR"/reload.sh
    ;;
  power)
    "$SCRIPT_DIR"/power.sh
    ;;
  esac
  ;;
esac
