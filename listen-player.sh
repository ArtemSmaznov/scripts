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
    # player info
    state)       listen_metadata_lc   status     ;;
    player)      listen_metadata_lc   playerName ;;
    state_icon)  listen_metadata_icon status     ;;
    volume_icon) listen_metadata_icon volume     ;;

    # flags
    loop)      listen_metadata_lc       loop      ;;
    shuffle)   listen_metadata_lc       shuffle   ;;
    flags)     listen_mpd_event options flags     ;;
    repeat)    listen_mpd_event options repeat    ;;
    random)    listen_mpd_event options random    ;;
    single)    listen_mpd_event options single    ;;
    consume)   listen_mpd_event options consume   ;;
    crossfade) listen_mpd_event options crossfade ;;
    update)    listen_mpd_event update  update    ;;

    # track info
    title)    listen_metadata title        ;;
    artist)   listen_metadata artist       ;;
    album)    listen_metadata album        ;;
    volume)   listen_metadata volume       ;;
    progress) listen_metadata position     ;;
    duration) listen_metadata mpris:length ;;

    # files
    track_file) listen_metadata_path      xesam:url    ;;
    cover_file) listen_metadata           mpris:artUrl ;;

    # mpd-stats
    rating)      listen_mpd_event player rating      ;;
    play_count)  listen_mpd_event player play_count  ;;
    skip_count)  listen_mpd_event player skip_count  ;;
    last_played) listen_mpd_event player last_played ;;

    *) listen_metadata $1 ;;
esac
