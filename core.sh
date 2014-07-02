#!/bin/sh

## Reference the README at the GitHub repo
## $1: The script name (call this function with $0)
phelp() {
	echo "https://github.com/thatJavaNerd/scripts#$(basename $1 .sh)sh"
}

## Prints a messate to the standard error
## $1: The error message
perror() {
	echo "Error: $1" 1>&2
}

## Checks if a command is available to use. If it is, this script exits with 0, otherwise 1.
## $1: The command to check
require() {
	which "$1f" 2>/dev/null
	echo $?
}

## Asks the user to confirm their actions. Echoes "0" if yes, "1" if no
## $1: The message to show the user
confirm() {
	while true; do
		read -p "$1" yn
		case $yn in
			[Yy]* ) echo 0; break;;
			[Nn]* ) echo 1; break;;
			* ) echo "Please answer yes or no.";;
		esac
	done
}

