#!/usr/bin/env bash
target="$1"

if [[ ! $target ]]; then
    # curl -s https://ipinfo.io/ip
    curl -s ifconfig.co
    exit
fi

host $target | awk '{ print $4 }'
