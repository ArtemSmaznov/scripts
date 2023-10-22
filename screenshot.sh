#!/usr/bin/env bash
scope="$1"

# env variables
#-------------------------------------------------------------------------------
[ ! "$XDG_PICTURES_DIR" ] && export XDG_PICTURES_DIR="$HOME/Pictures"

# variables
#-------------------------------------------------------------------------------
screen_dir="$XDG_PICTURES_DIR/screenshots"
screen_name="screenshot"
screen_format="png"

shutter="/usr/share/sounds/freedesktop/stereo/camera-shutter.oga"

# functions
#-------------------------------------------------------------------------------
set_screen_file() {
    timestamp=$(~/.local/bin/get-timestamp.sh)
    screen_file="$screen_dir/$screen_name-$timestamp.$screen_format"
}

screenshot_wayland() {
    set_screen_file
    if [[ ! $geometry ]]; then
        grim "$screen_file" || exit 1
    else
        grim -g "$geometry" "$screen_file" || exit 1
    fi

    paplay "$shutter"
}

screenshot_xorg() {
    exit 1
    maim -u --geometry "$geometry" | tee "$screen_file" | ~/.local/bin/save-to-clipboard.sh image/png || exit 1
    maim -u --capturebackground -i $(xdotool getactivewindow) | tee "$screen_file" | ~/.local/bin/save-to-clipboard.sh image/png || exit 1
    maim -u --capturebackground --select -n | tee "$screen_file" | ~/.local/bin/save-to-clipboard.sh image/png || exit 1
    maim -u | tee "$screen_file" | ~/.local/bin/save-to-clipboard.sh image/png || exit 1
}

screenshot_android() {
    remote_host="$1"
    remote_port="$2"

    screen_name="tv-screenshot"
    screen_format="png"
    set_screen_file

    remote_dir="/sdcard/Pictures/Screenshots"
    remote_file="$remote_dir/$screen_name.$screen_format"

    adb_device="$(~/.local/bin/get-ip.sh $remote_host):$remote_port"

    adb connect "$adb_device"
    adb -s "$adb_device" shell mkdir -p "$remote_dir"
    adb -s "$adb_device" shell screencap -p "$remote_file"
    paplay "$shutter"
    adb -s "$adb_device" pull "$remote_file" "$screen_file"
    adb -s "$adb_device" shell rm "$remote_file"
}

# setup
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
    tv)
        message="TV"
        ;;
    *)
        echo -e """error: invalid option '$scope'

accepted options:
  - monitor
  - area
  - window
  - desktop
  - tv"""
        exit 1
        ;;
esac

# execution
#===============================================================================
mkdir -p "${screen_dir}"

case $scope in
    tv) screenshot_android nvidia-shield 5555 ;;
    *) case $XDG_SESSION_TYPE in
           wayland) screenshot_wayland ;;
           x11) screenshot_xorg ;;
       esac
       ;;
esac

notify-send --urgency low "Screenshot saved!" "$message" --icon "$screen_file"
