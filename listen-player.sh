#!/usr/bin/env bash
player="$2"

# variables
#-------------------------------------------------------------------------------
player_arg=""
[ -n "$player" ] && player_arg="--player=$player"

# functions
#-------------------------------------------------------------------------------
listen_metadata () {
    playerctl metadata \
        --follow \
        "$player_arg" \
        --format "{{$1}}"
}

listen_metadata_lc () {
    playerctl metadata \
        --follow \
        "$player_arg" \
        --format "{{lc($1)}}"
}

listen_metadata_path () {
    playerctl metadata \
        --follow \
        "$player_arg" \
        --format "{{$1}}" |
        sed -e 's,file://,,' -e 's,%20, ,g'
}

listen_metadata_icon () {
    playerctl metadata \
        --follow \
        "$player_arg" \
        --format "{{emoji($1)}}"
}

# execution
#===============================================================================
case $1 in
    title)        listen_metadata           title        ;;
    artist)       listen_metadata           artist       ;;
    album)        listen_metadata           album        ;;
    volume)       listen_metadata           volume       ;;
    progress)     listen_metadata           position     ;;
    duration)     listen_metadata           mpris:length ;;

    state_icon)   listen_metadata_icon      status       ;;
    volume_icon)  listen_metadata_icon      volume       ;;

    state)        listen_metadata_lc        status       ;;
    player)       listen_metadata_lc        playerName   ;;
    shuffle)      listen_metadata_lc        shuffle      ;;
    loop)         listen_metadata_lc        loop         ;;

    track_file)   listen_metadata_path      xesam:url    ;;
    cover_file)   listen_metadata           mpris:artUrl ;;

    *)           listen_metadata           $1           ;;
esac
