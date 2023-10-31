#!/usr/bin/env bash
# variables
#-------------------------------------------------------------------------------
scripts_dir="$HOME/.local/bin"

# x11 functions
#-------------------------------------------------------------------------------
toggle_x11 () {
    case $("$scripts_dir/get-lang.sh") in
        'us') new_lang='ru' ;;
        'ru') new_lang='jp' ;;
        'jp') new_lang='us' ;;
        *) new_lang='us' ;;
    esac

    "$scripts_dir/set-lang.sh $new_lang"

    case $new_lang in
        'jp') fcitx5-remote -o ;; # enable japanese
        *) fcitx5-remote -c ;;    # disable japanese
    esac
}

# wayland functions
#-------------------------------------------------------------------------------
toggle_wayland () {
    case $XDG_CURRENT_DESKTOP in
        'Hyprland') toggle_hyprland ;;
    esac
}

toggle_hyprland () {
    keyboard_device="massdrop-inc.-ctrl-keyboard"
    hyprctl switchxkblayout "$keyboard_device" next
    case $("$scripts_dir/get-lang.sh") in
        'Japanese') fcitx5-remote -o ;; # enable japanese
        *) fcitx5-remote -c ;;          # disable japanese
    esac
}

# execution
#===============================================================================
case $XDG_SESSION_TYPE in
    'x11') toggle_x11 ;;
    'wayland') toggle_wayland ;;
esac
