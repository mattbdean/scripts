#!/bin/bash

#  Usage:
#  auto-pdf-images.sh <base-directory>
#  

shopt -s nullglob

cd $1

for file in *.pdf; do
	# Has extension ".pdf"

	basename=$(echo `basename "$file" .pdf`)
	echo $file
	echo $basename
	extract-pdf-images.sh "$file" "$basename" "$basename"
done

# Move back up to the previous directory
cd -