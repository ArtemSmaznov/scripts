#!/usr/bin/env bash
# environment variables --------------------------------------------------------
[ ! "$XDG_MUSIC_DIR" ] && export XDG_MUSIC_DIR="$HOME/Music"
[ ! "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"

# variables --------------------------------------------------------------------
music_dir="$XDG_MUSIC_DIR"
playlists_dir="$XDG_CONFIG_HOME/mpd/playlists"

# setup ------------------------------------------------------------------------
cd "$music_dir" || exit 1

# execution ====================================================================
echo "Broken song links:"
echo "------------------"
for playlist in "$playlists_dir"/*; do
    playlist=$(basename "$playlist" .m3u)

    while read -r song; do
        ls "$song" &>/dev/null || echo "$playlist: $song"
    done <"$playlists_dir/$playlist.m3u"
done
