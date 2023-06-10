#!/usr/bin/env bash
#
# Inputs
wallpaper_category=$1

if [ ! "$XDG_STATE_HOME" ]; then
    export XDG_STATE_HOME="$HOME/.local/state"
fi
wallpaper_category_file="$XDG_STATE_HOME/wallpaper"

if [ ! "$XDG_PICTURES_DIR" ]; then
    export XDG_PICTURES_DIR="$HOME/pictures"
fi
wallpapers_dir="$XDG_PICTURES_DIR/wallpapers"

#===============================================================================

function getLastCategory {
    last_category="faded"
    if [ -f "$wallpaper_category_file" ]; then
        last_category=$(cat "$wallpaper_category_file")
    fi
}

function handleCategoryInput {
    wallpaper_category="$1"
    if [ ! "$wallpaper_category" ]; then
        wallpaper_category="$last_category"
    fi
}

function updateStateFile {
    caterogy="$1"
    echo "$caterogy" >"$wallpaper_category_file"
}

function selectRandomWallpaper {
    category="$1"
    wallpaper=$(find "$wallpapers_dir/$category" -type f | shuf -n 1)
}

#-------------------------------------------------------------------------------
# Xorg

function setNitrogen {
    monitors=$(xrandr --query | grep -e '\sconnected' | awk '{print $1}')

    for monitor in $monitors; do
        nitrogen --set-zoom-fill --random --head="$monitor" "$wallpapers_dir/$wallpaper_category"
    done
}

#-------------------------------------------------------------------------------
# Wayland

function setHyprPaper {
    monitors=$(hyprctl -j monitors | jq -r '.[].name')

    if [ ! "$(pidof hyprpaper)" ]; then
        hyprpaper &
    fi

    hyprctl hyprpaper unload all

    for monitor in $monitors; do
        selectRandomWallpaper "$wallpaper_category"
        hyprctl hyprpaper preload "$wallpaper"
        hyprctl hyprpaper wallpaper "$monitor,$wallpaper"
    done
}

#===============================================================================

getLastCategory
handleCategoryInput "$wallpaper_category"
updateStateFile "$wallpaper_category"

if [[ $XDG_SESSION_TYPE == "x11" ]]; then
    setNitrogen
fi

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    # if [[ $XDG_DESKTOP_SESSION == "hyprland" ]]; then
    # if [[ $XDG_SESSION_DESKTOP == "Hyprland" ]]; then
    if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
        setHyprPaper
    fi
fi
