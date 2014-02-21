#!/bin/sh

DIRECTORY="/media/storage/Pictures/Wallpapers/Simple"
cd $DIRECTORY

gsettings set org.gnome.desktop.background picture-uri "file://$DIRECTORY/$(ls | shuf -n 1)"
