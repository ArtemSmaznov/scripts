#!/usr/bin/env bash
type="$1" # image/png
# screenshot.sh monitor | save-to-clipboard.sh image/png

case "$XDG_SESSION_TYPE" in
    'x11') xclip -selection clipboard -t "$type" ;;
    'wayland') wl-copy -t "$type" ;;
    *) err "Unknown display server" ;;
esac
