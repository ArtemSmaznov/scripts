#!/usr/bin/env bash
# options ----------------------------------------------------------------------
while getopts ":f:" opt; do
    case "$opt" in
        f) output_format="$OPTARG" ;;
        *) output_format="hex" ;;
    esac
done
shift $((OPTIND-1))

image="$1"

# setup ________________________________________________________________________
hex_color=$(convert "$image" -scale 1x1\! -format %c -colors 1 histogram:info:- 2>/dev/null |
                awk '{ print $3 }' |
                sed -e 's/\(#.\{6\}\).*/\1/')

rgb_color=$(convert -depth 8 xc:"$hex_color" txt: |
                tail +2 |
                awk '{ print $2 }' |
                tr -d '()')

# execution ********************************************************************
case $output_format in
    rgb) echo "$rgb_color" ;;
    hex) echo "$hex_color" ;;
    *) echo "$hex_color" ;;
esac
