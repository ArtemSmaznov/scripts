#!/usr/bin/env bash
image="$1"
[ $2 ] && colors=$2 || colors=1

convert "$image" -scale $colorsx$colors\! -format %c -colors $colors histogram:info:- | awk '{print $3}'
