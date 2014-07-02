#!/bin/bash

## Extracts all images from all PDFs in a given directory

shopt -s nullglob
DIR="$1"
DIR=${DIR:-.} # Default value of current directory
DIR=${DIR%/} # Remove leading forward slash

for file in "$DIR"/*.pdf; do
	# Operate on all PDFs
	basename=$(basename "$file" .pdf)
	echo "Extracting images in \"$file\" to \"$DIR/$basename/\""
	extr_pdf_imgs.sh "$file" "$basename" "$DIR/$basename"
done

