#!/usr/bin/env bash
target="$1"

if [[ ! $target ]]; then
    curl -s ifconfig.co
    exit
fi

host $target | awk '{ print $NF }'
