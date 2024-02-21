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
        --format "{{$1}}"
}

listen_metadata_icon () {
    playerctl metadata \
        --follow \
        "$player_arg" \
        --format "{{emoji($1)}}"
}

listen_mpd_event () {
    event="$1"
    field="$2"

    ~/.local/bin/get-music.sh "$field"

    mpc idleloop "$event" | while read -r line; do
        ~/.local/bin/get-music.sh "$field"
    done
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

    track_file)   listen_metadata_path      xesam:url    ;;
    cover_file)   listen_metadata           mpris:artUrl ;;

    shuffle)      listen_metadata_lc        shuffle      ;;
    loop)         listen_metadata_lc        loop         ;;

    rating)       listen_mpd_event  player  rating       ;;
    play_count)   listen_mpd_event  player  play_count   ;;
    skip_count)   listen_mpd_event  player  skip_count   ;;
    last_played)  listen_mpd_event  player  last_played  ;;

    *)           listen_metadata           $1           ;;
esac
