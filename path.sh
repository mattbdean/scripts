#!/bin/bash

source $(dirname $(readlink -f $0))/core.sh

FILE="$(echo ~)/.path"

if [ ! -f "$FILE" ]; then
	perror "$FILE does not exist"
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
		perror "Directory not found: \"$dir\""
		exit 2
	fi

	newpath="$newpath:$dir"
done < "$FILE"

echo $newpath

