#!/usr/bin/env bash
function get_all_players {
    playerctl --list-all
}

function get_current_player {
    playerctl --list-all | head -1
}

function get_player_state {
    player="$1"
    playerctl --player "$player" status
}

function pause_players_except {
    new_player="$1"
    players=$(get_all_players)

    for player in $players; do
        if [ "$player" != "$new_player" ]; then
            pause_player "$player"
        fi
    done
}

function pause_player {
    player=$1

    echo "[INFO] pausing player: $player"
    playerctl --player "$player" pause
}

last_player=""

while true; do
    new_player=$(get_current_player)
    new_player_state=$(get_player_state $new_player)

    if [[ "$new_player" != "$last_player" && "$new_player_state" == "Playing" ]]; then
        last_player="$new_player"
        pause_players_except "$new_player"
    fi

    sleep 1
done
