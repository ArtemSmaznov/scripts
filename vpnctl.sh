#!/usr/bin/env bash

# functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_status () {
    status=$(piactl get connectionstate)

    case $status in
        Disconnecting) echo -0.5      ;;
        Disconnected)  echo 0         ;;
        Connecting)    echo 0.5       ;;
        Connected)     echo 1         ;;
        *)             echo "$status" ;;
    esac
}

toggle_connection () {
    case $(get_status) in
        0) piactl connect    ;;
        1) piactl disconnect ;;
    esac
}

change_region () {
    region="$1"
    piactl set region "$region"
    piactl connect
}

# monitor functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
monitor_status () {
    piactl monitor connectionstate |
        while read -r line; do
            case "$line" in
                Disconnecting) echo -0.5    ;;
                Disconnected)  echo 0       ;;
                Connecting)    echo 0.5     ;;
                Connected)     echo 1       ;;
                *)             echo "$line" ;;
            esac
        done
}

# execution ********************************************************************
case $1 in
    status) get_status        ;;
    toggle) toggle_connection ;;

    set)
        case $2 in
            region) change_region "$3" ;;
        esac ;;

    get)
        case $2 in
            region)  piactl get region  ;;
            regions) piactl get regions ;;
        esac ;;


    monitor)
        case $2 in
            status) monitor_status        ;;
            region) piactl monitor region ;;
        esac ;;
esac
