#!/usr/bin/env bash

# shellcheck source=/home/nutty/.config/hypr/_config.sh
source "$HOME"/.config/hypr/_config.sh

case "$1" in
up)
  wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
  ;;
down)
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  ;;
lup)
  wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+
  ;;
ldown)
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-
  ;;
mute)
  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  ;;
mic-mute)
  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
  ;;
esac

if [[ "$1" == "mic-mute" ]]; then
  mic_info=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
  is_mic_muted=$(echo "$mic_info" | grep -c "MUTED")
  if [ "$is_mic_muted" -eq 1 ]; then
    "$SCRIPT_DIR"/osd.sh "Microphone" "Muted"
  else
    "$SCRIPT_DIR"/osd.sh "Microphone" "Unmuted"
  fi
  exit 0
fi

vol_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
volume=$(echo "$vol_info" | awk '{print int($2 * 100)}')
is_muted=$(echo "$vol_info" | grep -c "MUTED")

if [ "$is_muted" -eq 1 ]; then
  "$SCRIPT_DIR"/osd.sh "Volume" "Muted ($volume%)"
else
  "$SCRIPT_DIR"/osd.sh --bar "$volume" "Volume"
fi
