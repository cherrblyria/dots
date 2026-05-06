#!/usr/bin/env bash

# shellcheck source=/home/nutty/.config/hypr/_config.sh
source "$HOME"/.config/hypr/_config.sh

function yc() {
  tmp=$(mktemp -t "yazi-chooser.XXXXXX")
  yazi "$@" --chooser-file="$tmp"
  if [ -s "$tmp" ]; then
    cat "$tmp"
    rm -f -- "$tmp"
  fi
}

SYMLINK="$HOME/.cache/wallpaper"
HISTORY_FILE="$HOME/.cache/wallpaper_history"

function pick_random() {
  mapfile -t ALL < <(find -L "${WALLPAPER_PATH}" -type f -exec readlink -f {} \; | sort -u)
  WALL_COUNT=${#ALL[@]}

  TARGET_HISTORY=$((WALL_COUNT - WALL_RANDOM_POOL))
  [[ $TARGET_HISTORY -lt 0 ]] && TARGET_HISTORY=0

  mapfile -t HISTORY < <(cat "${HISTORY_FILE}" 2>/dev/null)

  # Trim history if it grew beyond target (e.g. you removed wallpapers)
  if [[ ${#HISTORY[@]} -gt $TARGET_HISTORY ]]; then
    TRIM=$((${#HISTORY[@]} - TARGET_HISTORY))
    HISTORY=("${HISTORY[@]:$TRIM}") # drop oldest from top
    printf '%s\n' "${HISTORY[@]}" >"${HISTORY_FILE}"
  fi

  # Build candidates: walls not in history
  CANDIDATES=()
  for w in "${ALL[@]}"; do
    skip=0
    for h in "${HISTORY[@]}"; do
      [[ "$w" == "$h" ]] && skip=1 && break
    done
    [[ $skip -eq 0 ]] && CANDIDATES+=("$w")
  done

  # Fallback (RANDOM_POOL >= wall count)
  [[ ${#CANDIDATES[@]} -eq 0 ]] && CANDIDATES=("${ALL[@]}")

  SELECTED="${CANDIDATES[RANDOM % ${#CANDIDATES[@]}]}"

  # Append and trim history to target size
  echo "${SELECTED}" >>"${HISTORY_FILE}"
  [[ $TARGET_HISTORY -gt 0 ]] &&
    tail -n "${TARGET_HISTORY}" "${HISTORY_FILE}" >"${HISTORY_FILE}.tmp" &&
    mv "${HISTORY_FILE}.tmp" "${HISTORY_FILE}"

  echo "${SELECTED}"
}

if [[ -n $1 ]]; then
  if [ "$1" == "random" ]; then
    SELECTED="$(pick_random)"
    echo "Selected random wallpaper: ${SELECTED}"
  else
    SELECTED=$1
    echo "Selected wallpaper: ${SELECTED}"
  fi
else
  SELECTED="$(yc "${WALLPAPER_PATH}")"

  if [ -z "${SELECTED}" ] || [ ! -f "${SELECTED}" ]; then
    echo "No wallpaper selected or file does not exist."
    exit 0
  fi

  echo "Selected wallpaper: ${SELECTED}"
fi

RESOLVED="$(readlink -f "${SELECTED}")"

notify-send -h string:x-canonical-private-synchronous:wallpaper "Setting wallpaper..." "${RESOLVED}"
ln -sf "${RESOLVED}" "${SYMLINK}"
awww img "${RESOLVED}" --transition-type center --transition-duration 1 --transition-fps 48 --transition-step 90
notify-send -t 1000 -h string:x-canonical-private-synchronous:wallpaper "Wallpaper set" "${RESOLVED}"
