#!/usr/bin/env bash
wallpaper_category=$1

# environment variables --------------------------------------------------------
[ ! "$XDG_PICTURES_DIR" ] && export XDG_PICTURES_DIR="$HOME/Pictures"
[ ! "$XDG_STATE_HOME" ] && export XDG_STATE_HOME="$HOME/.local/state"

# variables --------------------------------------------------------------------
wallpaper_category_file="$XDG_STATE_HOME/wallpaper"
wallpapers_dir="$XDG_PICTURES_DIR/wallpapers"

# functions --------------------------------------------------------------------
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
    # wallpaper=$(find "$wallpapers_dir/$category" -type f,l | shuf -n 1)
    wallpaper=$(find "$wallpapers_dir/$category" -type f | shuf -n 1)
}

# functions - x11 --------------------------------------------------------------
function setNitrogen {
    monitors=$(xrandr --query |
        grep -e '\sconnected' |
        awk '{print $1}')

    for monitor in $monitors; do
        nitrogen --set-zoom-fill --random --head="$monitor" "$wallpapers_dir/$wallpaper_category"
    done
}

# functions - wayland ----------------------------------------------------------
function setHyprPaper {
    monitors=$(hyprctl -j monitors | jq -r '.[].name')

    [ ! "$(pidof hyprpaper)" ] && hyprpaper &

    hyprctl hyprpaper unload all

    for monitor in $monitors; do
        selectRandomWallpaper "$wallpaper_category"
        hyprctl hyprpaper preload "$wallpaper"
        hyprctl hyprpaper wallpaper "$monitor,$wallpaper"
    done
}

function setWPaperD {
    config_file="$XDG_CONFIG_HOME/wpaperd/wallpaper.toml"
    sed -i "s|path = .*$|path = \"$wallpapers_dir/$wallpaper_category\"|" "$config_file"

    # restart wpaperd
    systemctl --user restart wpaperd.service
}

# execution ====================================================================
getLastCategory
handleCategoryInput "$wallpaper_category"
updateStateFile "$wallpaper_category"

case $XDG_SESSION_TYPE in
wayland)
    setWPaperD
    ;;

x11)
    export DISPLAY=":0"
    setNitrogen
    ;;

*) exit 1 ;;
esac
