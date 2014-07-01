#!/bin/bash

## Extracts all images from all PDFs in a given directory

shopt -s nullglob

cd $1

for file in *.pdf; do
	# Has extension ".pdf"

	basename=$(echo `basename "$file" .pdf`)
	echo $file
	echo $basename
	extr_pdf_imgs.sh "$file" "$basename" "$basename"
done

# Move back up to the previous directory
cd -
