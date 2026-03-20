#!/usr/bin/env bash

function yc() {
  local tmp=$(mktemp -t "yazi-chooser.XXXXXX")
  yazi "$@" --chooser-file="$tmp"
  if [ -s "$tmp" ]; then
    cat "$tmp"
    rm -f -- "$tmp"
  fi
}

SELECTED="$(yc "$HOME"/Pictures/Wallpapers)"

ln -sf "${SELECTED}" "$HOME"/.config/hypr/wal
hyprctl hyprpaper wallpaper ,"$HOME/.config/hypr/wal"
