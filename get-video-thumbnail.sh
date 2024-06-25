#!/usr/bin/env bash
video_file="$1"
size="$2"

# variables --------------------------------------------------------------------
[ -z "$video_file" ] && echo "[ERROR] video file required as an argument" && exit 1
[ -z "$size" ] && size=300

# execution ====================================================================
ffmpeg \
    -i "$video_file" \
    -ss 00:00:05 \
    -vframes 1 \
    -vf "thumbnail,crop=min(iw\,ih):min(iw\,ih),scale=$size:$size" \
    -loglevel quiet \
    -y \
    /tmp/thumbnail.jpg
