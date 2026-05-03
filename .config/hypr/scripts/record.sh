#!/usr/bin/env bash

# shellcheck source=/home/nutty/.config/hypr/_config.sh
source ~/.config/hypr/_config.sh

if pgrep -x "gpu-screen-reco" >/dev/null; then
  pkill -SIGINT -x gpu-screen-reco

  # Wait for the recording to finish saving
  while pgrep -x "gpu-screen-reco" >/dev/null; do sleep 0.1; done

  # Get the name of the last recorded mkv file
  LATEST_FILE=$(find "$SCREENRECORD_DIR" -maxdepth 1 -name '*.mkv' -printf '%T@ %f\n' | sort -rn | head -n 1 | cut -d' ' -f2-)
  notify-send -u low "Recording Stopped" "File saved to: $SCREENRECORD_DIR/$LATEST_FILE"
else
  gpu-screen-recorder -w screen -f 60 -a default_output -o "$SCREENRECORD_DIR/Screen Recording $(date +'%Y-%m-%d %H%M%S')".mkv &
  notify-send -u low "Recording Started" "Press Ctrl + Print Screen again to stop recording."
fi
