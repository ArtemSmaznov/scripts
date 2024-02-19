#!/usr/bin/env bash
function listen_metadata {
    playerctl metadata --follow --format "{{$1}}"
}

function listen_metadata_lc {
    playerctl metadata --follow --format "{{lc($1)}}"
}

function listen_metadata_path {
    playerctl metadata --follow --format "{{$1}}" | sed -e 's,file://,,' -e 's,%20, ,g'
}

function listen_metadata_icon {
    playerctl metadata --follow --format "{{emoji($1)}}"
}

case $1 in
    title)        listen_metadata       title        ;;
    artist)       listen_metadata       artist       ;;
    album)        listen_metadata       album        ;;
    volume)       listen_metadata       volume       ;;
    progress)     listen_metadata       position     ;;
    duration)     listen_metadata       mpris:length ;;

    state_icon)   listen_metadata_icon  status       ;;
    volume_icon)  listen_metadata_icon  volume       ;;

    state)        listen_metadata_lc    status       ;;
    player)       listen_metadata_lc    playerName   ;;
    shuffle)      listen_metadata_lc    shuffle      ;;
    loop)         listen_metadata_lc    loop         ;;

    track_file)   listen_metadata_path  xesam:url    ;;
    cover_file)   listen_metadata       mpris:artUrl ;;

    *)           listen_metadata       $1           ;;
esac
