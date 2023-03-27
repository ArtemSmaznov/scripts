#!/usr/bin/env bash
case $($HOME/.local/bin/get-lang.sh) in
    "us") new_lang="ru" ;;
    "ru") new_lang="jp" ;;
    "jp") new_lang="us" ;;
    *)   new_lang="us" ;;
esac

$HOME/.local/bin/set-lang.sh $new_lang

if [[ $new_lang == 'jp' ]]
then fcitx5-remote -o # enable japanese
else fcitx5-remote -c # disable japanese
fi
