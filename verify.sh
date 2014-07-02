#!/bin/bash --norc
# Use --norc to prevent using ~/.bashrc which could be indexed by verify.sh

## Verify that a file has not been modified since its original hashing. Requires super-user access.
##
## This script creates a hash of a file in ~/.verify.sh/ where the file name is the given file and
## its contents is the SHA-512 sum of the original file. This command exits with a non-zero code
## if the stored hashes of the given files did not equal their just-calculated hashes.

#HASH_DIRECTORY="/opt/scripts/hashes"
HASH_DIRECTORY="$HOME/.verify.sh"

help() {
	cat << EOF

verify.sh v0.2

Usage: verify.sh <files...> [-u | --update] [-h | --help]
	
	files...        A variable amount of files to check.
	-u | --update   Forces updating the hashes of the given files.
	-h | --help     Shows this message.

Examples:

    # Verify that a file called file_one.txt has not been modified
    # since it's last hash. If no hash file exists, a new one will
    # be created.
    $ verify.sh file_one.txt

    # Forces creating a new hash for a file called file_one.txt.
    # Requires superuser privileges.
    $ (sudo) verify.sh file_one.txt --update

    # Verify the integrity of all three files mentioned. If no has
    # is found, one will be generated.
    $ verify.sh file_one.txt file_two.txt file_three.txt

EOF
}

error() {
	help
	echo "Error: $1"
	exit 1
}

# Need root in order
if [ "$UID" -ne 0 ]; then
	error "Need to run as root"
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
	error "No files given!"
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
				echo "CHECKSUM MISMATCH: $file"
				exit 1
			fi
		fi
	else
		error "File does not exist: $file"
	fi
done
