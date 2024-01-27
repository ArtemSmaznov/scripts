#!/usr/bin/env bash
debug=false

if [[ $XDG_SESSION_TYPE == "x11" ]]; then
    # screen locker
    # xscreensaver -no-splash &
    # xautolock -time 60 -locker "$HOME/.config/i3lock/i3lock.sh" &
    xss-lock -- "$HOME/.config/i3lock/i3lock.sh" &

    # compositor
    picom -b &

    # hide cursor
    unclutter -jitter 5 &

    # blue screen filter
    redshift-gtk &
fi

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    # blue screen filter
    $XDG_CONFIG_HOME/wlsunset/wlsunset.sh &
fi

# dunst &
# emacs --daemon &
nm-applet &
blueman-applet &
nextcloud &

fcitx5 -d &

if ! $debug; then
    paplay "$HOME/public/audio/windows95-startup.wav" &

    /usr/bin/steam-runtime %U &
    qutebrowser &
    # emacsclient -c &

    sleep 10 && "$HOME/.local/bin/set-wallpaper.sh" &
fi
