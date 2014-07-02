#!/bin/bash

source core.sh

if [ "$#" -ne 3 ]; then
	perror "Three arguments are required"
	phelp $0
	exit 1
fi

mkdir -p "$2"
pdfimages -j "$1" "$2"/"$3"

mv "$1" "$2/source.pdf"
