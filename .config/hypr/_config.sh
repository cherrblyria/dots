#!/usr/bin/env bash

export OT="kitty --class fkitty fish -c"

export SCRIPT_DIR="$HOME/.config/hypr/scripts"
export WALLPAPER_PATH="$HOME/Pictures/Wallpapers"
export SCREENRECORD_DIR="$HOME/Videos/Screen Recordings"

export CURSOR_THEME="Remus-White"
export CURSOR_SIZE=24

export WALLPAPER_HISTORY_SIZE=15
export PLAYER=spotify

export DRUN="pkill rofi || true && rofi -show drun -show-icons"
export RUN="pkill rofi || true && rofi -show run"
export CLIP="pkill rofi || true && cliphist list | eval rofi -dmenu -display-columns 2 -p 'clipboard' | cliphist decode | wl-copy"
export EMOJI="pkill rofi || true && rofi -show emoji"

# shellcheck source=/home/nutty/.config/hypr/lib.sh
source "$HOME/.config/hypr/lib.sh"
