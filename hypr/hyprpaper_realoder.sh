#!/usr/bin/env bash

set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/walls/"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
  echo "Wallpaper directory does not exist: $WALLPAPER_DIR" >&2
  exit 1
fi

WALLPAPER=""
while IFS= read -r -d '' candidate; do
  WALLPAPER="$candidate"
done < <(
  find "$WALLPAPER_DIR" -type f \
    \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
    -print0 | shuf -z -n 1
)

if [[ -z "$WALLPAPER" ]]; then
  echo "No supported wallpaper images found in $WALLPAPER_DIR" >&2
  exit 1
fi

MONITOR="$(hyprctl monitors -j | jq -er 'first(.[] | select(.focused) | .name)')"

hyprctl hyprpaper wallpaper "$MONITOR, $WALLPAPER, cover"
