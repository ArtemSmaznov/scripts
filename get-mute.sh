#!/usr/bin/env bash

# execution ====================================================================
case $XDG_SESSION_TYPE in
wayland)
  muted=$(wpctl get-volume @DEFAULT_SINK@ |
    awk '{ print $3 }')

  [ "$muted" ] && echo on || echo off
  ;;

x11)
  stream=$(amixer sget Master |
    grep "%" |
    awk -F'[][]' '{print $4}' |
    sort -u)

  case $stream in
  on) echo off ;;
  *) echo on ;;
  esac
  ;;

*) exit 1 ;;
esac
