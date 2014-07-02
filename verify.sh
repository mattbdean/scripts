#!/bin/bash --norc
# Use --norc to prevent using ~/.bashrc which could be indexed by verify.sh


HASH_DIRECTORY="$HOME/.verify.sh"

help() {
	phelp $0
}

# Need root in order
if [ "$UID" -ne 0 ]; then
	perror "Need to run as root"
	help
	exit 1
fi

hash_file() {
	sha512sum "$file" | awk '{print $1}'
}

file_count=0
update_only=$(false)
files=()

# Read parameters
while test $# -gt 0; do
	case "$1" in
		-h|--help)
			help
			exit 0
			;;
		-u|--update)
			update_only=true
			shift
			;;
		*)
			files[$file_count]="$1"
			file_count=$(expr $file_count + 1)
			shift
			;;
	esac
done

if [ ${#files[@]} -eq 0 ]; then
	perror "No files given!"
	exit 2
fi

if [ ! -d "$HASH_DIRECTORY" ]; then
	mkdir "$HASH_DIRECTORY"
fi

# Iterate over the given files arguments
for file in ${files[@]}; do
	# Get the absolute path
	full_file=$(readlink -e "$file")
	if [ -f "$full_file" ]; then # The file must actually exist in order to continue
		hash_file="$HASH_DIRECTORY$full_file"
		# Make sure the directories for the hash exist
		mkdir -p $(dirname $hash_file)
		if [ ! -f "$hash_file" ] || [ $update_only ]; then
			# The hash file does not exist, create it
			hash_file "$full_file" > $hash_file
			# Make the file read-only by its owner, root
			chmod 400 "$hash_file" && echo "Created hash for \"$full_file\" at \"$hash_file\""
		else
			current_hash=$(hash_file "$file")
			file_hash=$(cat "$hash_file")

			if [ ! "$current_hash" == "$file_hash" ]; then
				perror "CHECKSUM MISMATCH: $file"
				exit 1
			fi
		fi
	else
		perror "File does not exist: $file"
		exit 3
	fi
done
