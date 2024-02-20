#!/usr/bin/env bash
# environment variables
#-------------------------------------------------------------------------------
[ ! "$XDG_MUSIC_DIR" ] && export XDG_MUSIC_DIR="$HOME/Music"

# variables
#-------------------------------------------------------------------------------
usage="""Usage:
    get-music.sh file
    get-music.sh albumcover
    get-music.sh albumcovercolor

    get-music.sh song
    get-music.sh title
    get-music.sh artist
    get-music.sh album

    get-music.sh state
    get-music.sh progress
    get-music.sh volume

    get-music.sh flags
    get-music.sh consume
    get-music.sh crossfade """

# functions
#-------------------------------------------------------------------------------
convert_mode () {
    if [ $(mpc status "%$1%") == "on" ]
    then echo "$2"
    else echo -
    fi
}

convert_crossfade () {
    if [[ $(mpc crossfade | awk '{print $2}') > 0 ]]
    then echo "$1"
    else echo -
    fi
}

convert_update () {
    if mpc status | grep -q 'Updating DB'
    then echo "$1"
    else echo -
    fi
}

get_track_file () {
    relative_file="$(mpc current -f %file%)"
    absolute_file="$XDG_MUSIC_DIR/$relative_file"

    echo "$absolute_file"
}

get_album_cover_file () {
    music_track_dir="$(dirname "$(get_track_file)")"
    album_cover_file=$(find "$music_track_dir" -type f -name "cover.*" | head -1)
    if [ -z "$album_cover_file" ]; then
        echo "$XDG_MUSIC_DIR/no-cover"
    else
        echo "$album_cover_file"
    fi
}

get_album_cover_color () {
    cover_file="$(get_album_cover_file)"
    ~/.local/bin/get-primary-color.sh "$cover_file"
}

get_flags () {
    flags=(
        $(convert_mode repeat r)
        $(convert_mode random z)
        $(convert_mode single s)
        $(convert_mode consume c)
        $(convert_crossfade x)
        $(convert_update U)
    )

    for flag in "${flags[@]}"; do
        mpd_flags+="$flag"
    done

    echo "[$mpd_flags]"
}

get_progress () {
    music_progress=$(mpc status "%percenttime%" | cut -c-3 | tr -d '[:space:]')
    echo "$music_progress"
}

# execution
#===============================================================================
case $1 in
    file) get_track_file ;;
    albumcover) get_album_cover_file ;;
    albumcovercolor) get_album_cover_color ;;

    song) mpc current -f "%artist% · %title%" ;;

    title) mpc current -f "%title%" ;;
    album) mpc current -f "%album%" ;;
    artist) mpc current -f "%artist%" ;;

    state) mpc status "%state%" ;;
    progress) get_progress ;;
    volume) mpc status "%volume%" ;;

    flags) get_flags ;;
    consume) convert_mode consume c ;;
    crossfade) convert_crossfade x ;;

    *) echo "$usage"
esac
