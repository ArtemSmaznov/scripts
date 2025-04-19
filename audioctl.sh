#!/usr/bin/env bash

# functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function list_outputs() {
    unformatted=$(wpctl status |
        sed -n '/^Audio/,/^Video/p' |
        sed -n '/Sinks:/,/Sources:/p' |
        tail -n +2 |
        head -n -2)

    echo "$unformatted" |
        tr --delete '│*' |
        awk -F '[' '{ print $1 }' |
        awk -F '.' '{ print $2 }' |
        sed -e 's/^ //' \
            -e 's/ \/.*$//'
}

function switch_output() {
    new_output="$1"
    wpctl set-default $(get_output_id "$new_output")
}

function get_default_output() {
    unformatted=$(wpctl status |
        sed -n '/^Audio/,/^Video/p' |
        sed -n '/Sinks:/,/Sources:/p' |
        tail -n +2 |
        head -n -2)

    echo "$unformatted" |
        grep \* |
        tr --delete '│*' |
        awk -F '[' '{ print $1 }' |
        awk -F '.' '{ print $2 }' |
        sed -e 's/^ //' \
            -e 's/ \/.*$//'
}

function get_output_id() {
    output="$1"

    unformatted=$(wpctl status |
        sed -n '/^Audio/,/^Video/p' |
        sed -n '/Sinks:/,/Sources:/p' |
        tail -n +2 |
        head -n -2)

    echo "$unformatted" |
        grep "$output" |
        tr --delete '│*' |
        awk -F '.' '{ print $1 }'
}

# execution ********************************************************************
case $1 in
list)
    case $2 in
    outputs) list_outputs ;;
    esac
    ;;
get)
    case $2 in
    default) get_default_output ;;
    esac
    ;;
switch) switch_output "$2" ;;
esac
