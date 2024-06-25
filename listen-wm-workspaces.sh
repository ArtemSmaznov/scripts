#!/usr/bin/env bash
# execution ====================================================================
case $XDG_SESSION_TYPE in
    x11)
        case $DESKTOP_SESSION in
            xmonad)
                xprop -spy -root _XMONAD_LOG |
                    stdbuf -oL sed 's/^.*= //' |
                    stdbuf -oL sed 's/^"\(.*\)"$/\1/' |
                    stdbuf -oL awk -F'::::' "{ print \$1 }"
                ;;
            *) exit 1 ;;
        esac ;;

    *) exit 1 ;;
esac

exit 0
