#!/usr/bin/env bash
music_dir="$XDG_MUSIC_DIR"
playlists_dir="$XDG_CONFIG_HOME/mpd/playlists"

cd "$music_dir" || exit 1

echo "Broken song links:"
echo "------------------"
for playlist in "$playlists_dir"/*; do
    playlist=$(basename "$playlist" .m3u)

    while read -r song; do
        ls "$song" &>/dev/null || echo "$playlist: $song"
    done <"$playlists_dir/$playlist.m3u"
done
