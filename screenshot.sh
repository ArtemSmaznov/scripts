#!/usr/bin/env bash
scope="$1"

[ ! "$XDG_PICTURES_DIR" ] && export XDG_PICTURES_DIR="$HOME/Pictures"

screen_dir="$XDG_PICTURES_DIR/screenshots"
screen_name="screenshot"
screen_format="png"
screen_file="$screen_dir/$screen_name-$(~/.local/bin/get-timestamp.sh).$screen_format"

shutter="/usr/share/sounds/freedesktop/stereo/camera-shutter.oga"

mkdir -p "${screen_dir}"

#-------------------------------------------------------------------------------

xorg_screen() {
    maim -u --geometry "$geometry" | tee "$screen_file" | ~/.local/bin/save-to-clipboard.sh image/png || exit 1
    maim -u --capturebackground -i $(xdotool getactivewindow) | tee "$screen_file" | ~/.local/bin/save-to-clipboard.sh image/png || exit 1
    maim -u --capturebackground --select -n | tee "$screen_file" | ~/.local/bin/save-to-clipboard.sh image/png || exit 1
    maim -u | tee "$screen_file" | ~/.local/bin/save-to-clipboard.sh image/png || exit 1
}

#-------------------------------------------------------------------------------

case $scope in
    monitor)
        message="Active monitor"
        geometry=$(~/.local/bin/get-geometry-monitor.sh) || exit 1
        ;;
    area)
        message="Area selection"
        geometry=$(~/.local/bin/get-geometry-area.sh) || exit 1
        ;;
    window)
        message="Active window"
        geometry=$(~/.local/bin/get-geometry-window.sh) || exit 1
        ;;
    desktop)
        message="Full desktop"
        geometry=$(~/.local/bin/get-geometry-desktop.sh) || exit 1
        ;;
    *)
        echo -e """error: invalid option '$scope'

accepted options:
  - monitor
  - area
  - window
  - desktop"""
        exit 1
        ;;
esac

#===============================================================================

if [[ $geometry ]]; then
    grim -g "$geometry" "$screen_file" || exit 1
else
    grim "$screen_file" || exit 1
fi

paplay "$shutter"
notify-send --urgency low "Screenshot saved!" "$message" --icon "$screen_file"
