#!/usr/bin/env bash
scope="$1"

# environment variables
#-------------------------------------------------------------------------------
[ ! "$XDG_VIDEOS_DIR" ] && export XDG_VIDEOS_DIR="$HOME/Videos"

# variables
#-------------------------------------------------------------------------------
record_dir="$XDG_VIDEOS_DIR/recordings"
record_name="recording"
record_format="mp4"
record_file="$record_dir/$record_name-$(~/.local/bin/get-timestamp.sh).$record_format"
record_delay=3

mkdir -p "${record_dir}"

# Audio Settings
audio_device='alsa_output.usb-Focusrite_Scarlett_2i2_USB_Y86EP6H211E46C-00.analog-stereo.monitor'

# Xorg

# Video Settings
resolution='1920x1080'
fps='30'

# functions
#-------------------------------------------------------------------------------
xorg_capture() {
    ffmpeg \
        -video_size $resolution -framerate $fps \
        -f x11grab -i "$DISPLAY" \
        -f pulse -ac 2 -i $audio_device \
        -codec:v libx264 -preset ultrafast \
        -codec:a copy \
        $record_dir/screenrecording-$(~/.local/bin/get-timestamp.sh).mkv
}

Setup
#-------------------------------------------------------------------------------
case $scope in
    monitor)
        message="Active monitor"
        geometry=$(~/.local/bin/get-geometry-monitor.sh) || exit 1
        ;;
    area)
        message="Area selection"
        geometry=$(~/.local/bin/get-geometry-area.sh) || exit 1
        ;;
    window)
        message="Active window"
        geometry=$(~/.local/bin/get-geometry-window.sh) || exit 1
        ;;
    desktop)
        message="Full desktop"
        geometry=$(~/.local/bin/get-geometry-desktop.sh) || exit 1
        ;;
    *)
        echo -e """error: invalid option '$scope'

accepted options:
  - monitor
  - area
  - window
  - desktop"""
        exit 1
        ;;
esac

# execution
#===============================================================================
~/.local/bin/trigger-countdown.sh $record_delay

if [[ $geometry ]]; then
    wf-recorder --audio="$audio_device" --file="$record_file" -g "$geometry" || exit 1
else
    wf-recorder --audio="$audio_device" --file="$record_file" || exit 1
fi

notify-send --urgency=low "Recording saved!" "$message"
