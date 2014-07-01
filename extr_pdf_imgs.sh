#!/bin/bash

## Extracts all images from a PDF and puts them in a given directory with a given prefix

help() {
	cat << EOF

Extract PDF Images v1.0

This is a simple script to extract images from a PDF and put them into a folder with a common base name.

Usage: sh extr_pdf_imgs.sh <pdf-name> <directory-name> <base-name>

Arguments:
    <pdf-name>         The name of the PDF file to extract the images from
    <directory-name>   The directory to extract (and make if it doesn\'t exist) the files into
    <base-name>        The common base-name of every picture from the

EOF

exit 1
}

if [ "$#" -ne 3 ]; then
	help
fi

mkdir -p "$2"
pdfimages -j "$1" "$2"/"$3"

mv "$1" "$2/source.pdf"
