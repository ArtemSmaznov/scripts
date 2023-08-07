#!/usr/bin/env bash
if [[ $XDG_SESSION_TYPE == "x11" ]]; then
    case $($HOME/.local/bin/get-lang.sh) in
        "us") new_lang="ru" ;;
        "ru") new_lang="jp" ;;
        "jp") new_lang="us" ;;
        *) new_lang="us" ;;
    esac

    $HOME/.local/bin/set-lang.sh $new_lang

    if [[ $new_lang == 'jp' ]]; then
        fcitx5-remote -o # enable japanese
    else
        fcitx5-remote -c # disable japanese
    fi
fi

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    # if [[ $XDG_DESKTOP_SESSION == "hyprland" ]]; then
    # if [[ $XDG_SESSION_DESKTOP == "Hyprland" ]]; then
    if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
        case $($HOME/.local/bin/get-lang.sh) in
            "Japanese") fcitx5-remote -o ;; # enable japanese
            *) fcitx5-remote -c ;;          # disable japanese
        esac
    fi
fi
