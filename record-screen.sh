#!/usr/bin/env bash
#
scope="$1"

if [ ! "$XDG_VIDEOS_DIR" ]; then
    export XDG_VIDEOS_DIR="$HOME/videos"
fi

record_format="mp4"
record_dir="$XDG_VIDEOS_DIR/recordings"
record_file="$record_dir/screenrecording-$(~/.local/bin/get-timestamp.sh).$record_format"
record_delay=3

mkdir -p "${record_dir}"

#-------------------------------------------------------------------------------
# Xorg

# Video Settings
resolution='1920x1080'
fps='30'

# Audio Settings
audio_device='alsa_output.usb-Focusrite_Scarlett_2i2_USB_Y86EP6H211E46C-00.analog-stereo.monitor'

xorg_capture() {
    ffmpeg \
        -video_size $resolution -framerate $fps \
        -f x11grab -i "$DISPLAY" \
        -f pulse -ac 2 -i $audio_device \
        -codec:v libx264 -preset ultrafast \
        -codec:a copy \
        $record_dir/screenrecording-$(~/.local/bin/get-timestamp.sh).mkv
}

#-------------------------------------------------------------------------------

case $scope in
    desktop)
        message="Full desktop"
        geometry=$(~/.local/bin/get-geometry-desktop.sh) || exit 1
        ;;
    monitor)
        message="Active monitor"
        geometry=$(~/.local/bin/get-geometry-monitor.sh) || exit 1
        ;;
    window)
        message="Active window"
        geometry=$(~/.local/bin/get-geometry-window.sh) || exit 1
        ;;
    area)
        message="Area selection"
        geometry=$(~/.local/bin/get-geometry-area.sh) || exit 1
        ;;
    *) echo -e """Only the following arguments are accepted:
  - desktop
  - monitor
  - window
  - area"""
        exit 1
        ;;
esac

#===============================================================================

~/.local/bin/trigger-countdown.sh $record_delay

if [[ $geometry ]]; then
    wf-recorder --audio --file="$record_file" -g "$geometry" || exit 1
else
    wf-recorder --audio --file="$record_file" || exit 1
fi

notify-send --urgency=low "Screen recording saved!" "$message"
