#!/bin/bash

which youtube-dl &>/dev/null
if [ ! $? -eq 0 ]; then
	echo "youtube-dl is required for this script"
fi

which ffmpeg &>/dev/null
if [ ! $? -eq 0 ]; then
	echo "ffmpeg is required for this script"
fi

youtube-dl "$1" --extract-audio --audio-format wav

