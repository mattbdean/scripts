#!/bin/bash

if [ $(require youtube-dl) -eq 1 ]; then
	perror "This script requires youtube-dl"
	exit 1
fi

if [ $(require ffmpeg) -eq 1 ]; then
	perror "This script requires ffmpeg"
	exit 2
fi

youtube-dl "$1" --extract-audio --audio-format mp3

