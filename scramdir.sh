#!/bin/bash

help() {
	cat << EOF
Purpose: Scramble the names of all files in a directory
Usage: scramdir.sh [folder]
Version: 1.0

EOF
}

BASE_FOLDER="$1"
BASE_FOLDER=${BASE_FOLDER:-.}
BASE_FOLDER=${BASE_FOLDER%/}
FILE_LENGTH=7

get_random_name() {
	cat /dev/urandom | tr -cd 'a-z0-9' | head -c $FILE_LENGTH
}

if [ ! -d "$BASE_FOLDER" ]; then
	echo "Directory \"$BASE_FOLDER\" does not exist"
	exit 1
fi

# Ask for confirmation
while true; do
	read -p "Really shuffle all files in $(readlink -f $BASE_FOLDER)? [y/n]" yn
	case $yn in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) echo "Please answer yes or no.";;
	esac
done

counter=0
for f in $BASE_FOLDER/*; do
	if [ ! -f "$f" ]; then
		# Only operate on files
		continue
	fi

	if [ "$(readlink -f $f)" == "$(readlink -f $0)" ]; then
		echo "Skipping script file ($0)"
		continue
	fi
	
	extension=$(echo "$f" | awk -F . '{print $NF}')
	if [ "$extension" == "$f" ]; then
		# No file extension, don't operate
		echo "Skipping $f (no file extension)"
		continue
	fi

	random=$(get_random_name)
	full_path="$BASE_FOLDER/$random.$extension"
	echo "$f --> $full_path" 1>&2
	mv "$f" "$full_path"
	counter=$[counter + 1]
done

echo "Renamed $counter files"
