#!/bin/bash

source $(dirname $(readlink -f $0))/core.sh

BASE_SIZE="48"
image="$1"
base_dir="$2"
base_dir=${base_dir:-.} # Default value of the current directory
base_dir=${base_dir%/} # Remove leading forward slash

# Need imagemagick
if [ $(require convert) -eq 1 ]; then
	perror "This script requires imagemagick"
	exit 1
fi

if [ ! -f "$image" ]; then
	perror "\"$image\" does not exist"
	exit 2
fi

if [ ! -d "$base_dir" ]; then
	perror "\"$base_dir\" does not exist"
	exit 3

declare -A SIZES=([mdpi]=1 [hdpi]=1.5 [xhdpi]=2 [xxhdpi]=3)

for res_name in "${!SIZES[@]}"; do
	# Resize the image from the original to $BASE_SIZE times $size
	mult=${SIZES[$res_name]}
	dir="$base_dir/drawable-$res_name"
	# Calculate the new size
	dim=$(echo "$BASE_SIZE * $mult" | bc)
	echo "Resizing $image to $dir ($dim x $dim)"
	
	if [ ! -d "$dir" ]; then
		mkdir "$dir"
	fi

	convert "$image" -resize "$dim"x"$dim" "$dir/$image"
done

