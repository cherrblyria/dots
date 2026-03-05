#!/usr/bin/env bash

if pgrep -x "gpu-screen-reco" >/dev/null; then
  pkill -SIGINT -x gpu-screen-reco

  # Wait for the recording to finish saving
  while pgrep -x "gpu-screen-reco" >/dev/null; do sleep 0.1; done

  # Get the name of the last recorded mkv file
  LATEST_FILE=$(ls -t ~/Videos/ | grep '\.mkv$' | head -n 1)
  notify-send "Recording Stopped" "File saved to: ~/Videos/$LATEST_FILE"
else
  gpu-screen-recorder -w screen -f 60 -a default_output -o $HOME/Videos/"$(date +'%Y-%m-%d %H-%M-%S')".mkv &
  notify-send "Recording Started" "Press Ctrl + Print Screen again to stop recording."
fi
