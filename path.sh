#!/bin/bash

## This script reads a file at ~/.path and every directory (if it exists) to a $PATH-like
## variable. Empty lines and ones that start with a '#' ar ignored. At the end of this
## script, the new path variable is echoed out for use in other scripts.
##
## Sample usage:
##
##    newpath=$(path.sh)
##    if [ $? -eq 0 ]; then
##        export PATH=$newpath
##    else
##        # $newpath has the error message from path.sh
##        echo $newpath
##    fi
##
## Exit codes:
##   1 - ~/.path does not exist
##   2 - A directory in ~/.path does not exist
##

FILE="$(echo ~)/.path"

if [ ! -f "$FILE" ]; then
	echo "$FILE does not exist" 1>&2
	exit 1
fi

newpath=$PATH

# http://stackoverflow.com/a/10929511
while read -r line; do
	# Ignore empty lines
	[ -z "$line" ] && continue
	# Ignore lines starting with "#" (comments)
	[[ ${line:0:1} == "#" ]] && continue

	dir=$line

	if [ ! -d "$dir" ]; then
		echo "Directory not found: \"$dir\"" 1>&2
		exit 2
	fi

	newpath="$newpath:$dir"
done < "$FILE"

echo $newpath

