#!/bin/bash

error() {
	help
	echo "Error: $1"
	exit 1
}

help() {
	cat << EOF
andricon.sh v1.0

This script uses imagemagick to resize an image to fit the specification of
android "drawable" images.

Usage: andricon.sh <icon> [res-root]

    <icon>     The image to use
    [res-root] The directory which contains all of the drawable-* direcotires. Usually called "res".
               If this parameter is not used, then the current directory is assumed.

Examples:
	# Resize an icon called my_icon.png
	andricon.sh my_icon.png

	# Resize an icon called my_icon.png, where the base directory is projects/MyApp/src/res/
	andricon.sh my_icon.png MyApp/src/res
EOF
}

require_imagemagick() {
	which convert &>/dev/null
	if [ $? -eq 1 ]; then
		error "This script requires imagemagick"
	fi
}

BASE_SIZE="48"
image="$1"
base_dir="$2"

if [[ -z "$base_dir" ]]; then
	# base_dir was not specified
	base_dir="./"
elif [[ "$base_dir" != "*/" ]]; then
	# Does not end with a forward slash, add it
	base_dir="$base_dir/"
fi

require_imagemagick

if [[ -z "$image" ]]; then
	error "No input file specified"
fi

declare -A SIZES=([mdpi]=1 [hdpi]=1.5 [xhdpi]=2 [xxhdpi]=3)

for res_name in "${!SIZES[@]}"; do
	# Resize the image from the original to $BASE_SIZE times $size
	mult=${SIZES[$res_name]}
	dir="$(echo $base_dir)drawable-$res_name"
	# Calculate the new size
	dim=$(echo "$BASE_SIZE * $mult" | bc)
	echo "Resizing $image to $dir ($dim x $dim)"
	
	convert "$image" -resize "$dim"x"$dim" "$dir/$image"
done

