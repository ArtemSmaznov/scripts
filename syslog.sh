#!/usr/bin/env bash

function has_command() {
    hash "$1" 2>/dev/null
    return $?
}

if has_command ccze; then
    journalctl --follow | ccze
elif has_command tspin; then
    journalctl --follow | tspin
else
    journalctl --follow
fi
