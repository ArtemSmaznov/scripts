#!/usr/bin/env bash
paplay "$HOME/public/audio/windows95-startup.wav" &

if [[ $XDG_SESSION_TYPE == "x11" ]]; then
    # wallpaper
    ~/.local/bin/dm-scripts/dm-wallpaper -refresh &

    # screen locker
    # xscreensaver -no-splash &
    # xautolock -time 60 -locker "$HOME/.config/i3lock/i3lock.sh" &
    xss-lock -- "$HOME/.config/i3lock/i3lock.sh" &

    # compositor
    picom -b &

    # notification daemon
    dunst &

    # hide cursor
    unclutter -jitter 5 &

    # blue screen filter
    redshift-gtk &
fi

# if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
# fi

nm-applet &
blueman-applet &
nextcloud &

fcitx5 -d &

# emacs --daemon &

/usr/bin/steam-runtime %U &
emacsclient -c -a 'emacs' &
alacritty --class ncmpcpp -e ncmpcpp &
alacritty --class btop -e btop &
qutebrowser &
