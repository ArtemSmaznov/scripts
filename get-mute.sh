#!/usr/bin/env bash
# variables --------------------------------------------------------------------
stream=$( amixer sget Master |
              grep "%" |
              awk -F'[][]' '{print $4}' |
              sort -u )

# execution ====================================================================
case $stream in
    on) echo off ;;
    *) echo on ;;
esac
