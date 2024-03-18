#!/usr/bin/env bash
type="$1" # image/png
# screenshot.sh monitor | save-to-clipboard.sh image/png

# execution
#===============================================================================
case "$XDG_SESSION_TYPE" in
    wayland) wl-copy -t "$type" ;;

    x11) xclip -selection clipboard -t "$type" ;;

    *) err "Unknown display server" ;;
esac
