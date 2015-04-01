#!/bin/bash

source $(dirname $(readlink -f $0))/core.sh

dir="$1"
dir=${dir:-.} # Default value of the current directory
dir=${dir%/} # Remove leading forward slash

# Ask for confirmation
while true; do
	read -p "Really correct all file extensions in \"$dir/\"? [y/n] " yn
	case $yn in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) echo "Please answer yes or no.";;
	esac
done

for file in "$dir"/*; do
	if [ ! -f "$file" ]; then
		# Operate only on files
		continue;
	fi

	mime=$(file --mime-type $file | awk '{print $2}')
	if [ "$mime" == "text/html" ]; then
		perror "$file is an HTML page"
	fi

	new_ext=$(
		case "$mime" in
			("image/gif") echo "gif";;
			("image/jpeg") echo "jpg";;
			("image/png") echo "png";;
			("image/svg+xml") echo "svg";;
			("video/webm") echo "webm";;
			("audio/webm") echo "webm";;
		esac)
	
	if [ -z "$new_ext" ]; then
		# TODO verbose option?
		#echo "Could not find extension for $file"
		continue
	fi
	
	old_ext=$(echo "$file" | awk -F . '{print $NF}')
	if [ "$old_ext" == "$file" ]; then
		# No file extension
		name=$(basename $file)
	else
		name=$(basename $file .$old_ext)
	fi

	full_path="$dir/$name.$new_ext"

	if [ "$full_path" == "$file" ]; then
		# No change
		continue;
	fi

	echo "$file --> $full_path"
	mv "$file" "$full_path"

done
