#!/bin/bash

source $(dirname $(readlink -f $0))/core.sh

TRUE=1
FALSE=0

help() {
	phelp $0
}

get_random_name() {
	cat /dev/urandom | tr -cd 'a-z0-9' | head -c $FILE_LENGTH
}

FILE_LENGTH=7

force=$FALSE
quiet=$FALSE
simulate=$FALSE

# Read parameters
while test $# -gt 0; do
	case "$1" in
		-h|--help)
			help
			exit 0
			;;
		-f|--force)
			force=$TRUE
			shift
			;;
		-q|--quiet)
			quiet=$TRUE
			shift
			;;
		-s|--simulate)
			simulate=$TRUE
			shift
			;;
		*)
			if [ ! -z "$BASE_FOLDER" ]; then
				perror "Base folder already specified"
				exit 1
			fi

			BASE_FOLDER="$1"
			BASE_FOLDER=${BASE_FOLDER%/}
			shift
			;;
	esac
done

# Default value of the current directory
BASE_FOLDER=${BASE_FOLDER:-.}

if [ ! -d "$BASE_FOLDER" ]; then
	echo "Directory \"$BASE_FOLDER\" does not exist"
	exit 2
fi

if [ $force -eq "$FALSE" ]; then
	# Ask for confirmation
	code=$(confirm "Really shuffle all files in $(readlink -f $BASE_FOLDER)? [y/n] ")

	if [ $code -ne 0 ]; then
		exit 3
	fi
fi

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
	if [ "$quiet" -eq "$FALSE" ]; then
		echo "$f --> $full_path"
	fi

	if [ "$simulate" -eq "$FALSE" ]; then
		mv "$f" "$full_path"
	fi
	counter=$((counter + 1))
done

echo "Renamed $counter files in $(readlink -f $BASE_FOLDER)"
