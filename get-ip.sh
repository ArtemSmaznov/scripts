#!/usr/bin/env bash
target="$1"

# execution ====================================================================
if [[ ! $target ]]; then
    curl -s ifconfig.co
    exit
fi

host $target |
    awk '{ print $NF }'
