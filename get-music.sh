#!/usr/bin/env bash
stat="$1"

# environment variables
#-------------------------------------------------------------------------------
[ ! "$XDG_MUSIC_DIR" ] && export XDG_MUSIC_DIR="$HOME/Music"

# variables
#-------------------------------------------------------------------------------
usage="""Usage:
    get-music.sh state
    get-music.sh progress
    get-music.sh volume

    get-music.sh flags
    get-music.sh repeat
    get-music.sh random
    get-music.sh single
    get-music.sh consume
    get-music.sh crossfade
    get-music.sh update

    get-music.sh song
    get-music.sh title
    get-music.sh artist
    get-music.sh album

    get-music.sh file
    get-music.sh albumcover
    get-music.sh albumcovercolor

    get-music.sh rating
    get-music.sh play_count
    get-music.sh skip_count
    get-music.sh last_played """

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

    [ -z "$relative_file" ] && echo "" && return

    absolute_file="$XDG_MUSIC_DIR/$relative_file"
    echo "$absolute_file"
}

get_album_cover_file () {
    track_file="$(get_track_file)"
    [ -z "$track_file" ] && return

    music_track_dir="$(dirname "$track_file")"
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

get_track_metadata () {
    field=$1

    track_file="$(get_track_file)"
    if [ -z "$track_file" ]; then
        echo 0
        return
    fi

    value="$(~/.local/bin/get-song-metadata.sh $field "$track_file")"

    [ "$value" == '$rating'      ] && echo 0.5 && return
    [ "$value" == '$play_count'  ] && echo 0   && return
    [ "$value" == '$skip_count'  ] && echo 0   && return
    [ "$value" == '$last_played' ] && return

    echo "$value"
}

# execution
#===============================================================================
case $1 in
    # player info
    state)    mpc status "%state%"  ;;
    progress) get_progress          ;;
    volume)   mpc status "%volume%" ;;

    # flags
    flags)     get_flags              ;;
    repeat)    convert_mode repeat  r ;;
    random)    convert_mode random  z ;;
    single)    convert_mode single  s ;;
    consume)   convert_mode consume c ;;
    crossfade) convert_crossfade    x ;;
    update)    convert_update       U ;;

    # track info
    song)   mpc current -f "%artist% · %title%" ;;
    title)  mpc current -f "%title%"            ;;
    album)  mpc current -f "%album%"            ;;
    artist) mpc current -f "%artist%"           ;;

    # files
    file)            get_track_file ;;
    albumcover)      get_album_cover_file ;;
    albumcovercolor) get_album_cover_color ;;

    # mpd-stats
    rating)      get_track_metadata "$stat" ;;
    play_count)  get_track_metadata "$stat" ;;
    skip_count)  get_track_metadata "$stat" ;;
    last_played) get_track_metadata "$stat" ;;

    *) echo "$usage"
esac
