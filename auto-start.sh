#!/usr/bin/env bash
debug=false

# execution
#===============================================================================
case $XDG_SESSION_TYPE in
    wayland)
        case $XDG_SESSION_DESKTOP in
            Hyprland)
                # blue screen filter
                $XDG_CONFIG_HOME/wlsunset/wlsunset.sh &
                ;;
            *) exit 1 ;;
        esac ;;

    x11)
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
        ;;

    *) exit 1 ;;
esac

# dunst &
nm-applet &
blueman-applet &
nextcloud --background &

fcitx5 -d &

if ! $debug; then
    paplay "$HOME/public/audio/windows95-startup.wav" &

    /usr/bin/steam-runtime %U &
    qutebrowser &
    emacs &
    # emacsclient -ca '' &

    sleep 10 && "$HOME/.local/bin/set-wallpaper.sh" &
fi
