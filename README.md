My bash scripts
===============

A few scripts that I use. Nothing (too) special.
##[`andricon.sh`](https://github.com/thatJavaNerd/scripts/blob/master/andricon.sh)

This script uses imagemagick to copy and resize an image into the different `drawable-*` directories usually found in `src/main/res/` in an Android project. The sizes are based on Android's [Iconography](https://developer.android.com/design/style/iconography.html) page. This script will generate:

1. A 48x48 px image in `$base_dir/drawable-mdpi`

2. A 72x72 px image in `$base_dir/drawable-hdpi`

3. A 96x96 px image in `$base_dir/drawable-xhdpi`

4. A 144x144 px image in `$base_dir/drawable-xxhdpi`

####Usage

`$ andricon.sh <icon> [base_dir]`

####Arguments

Name | Description
---- | -----------
`icon` | The image to use
`base_dir` | The place to output the resized files to. Defaults to the current directory

####Examples

```shell
# Resize an icon called my_icon.png
user@hostname:~$ andricon.sh my_icon.png
# Resize an icon called my_icon.png, where the base directory is projects/MyApp/src/res/
user@hostname:~$ andricon.sh my_icon.png MyApp/src/res
```
####Exit codes

Code | Description
---- | -----------
`0` | Exited normally
`1` | If imagemagick is not installed
`2` | If the given file does not exist
`3` | If the given base directory does not exist

####Dependencies

- [`imagemagick`](http://www.imagemagick.org/)

##[`auto_pdf_images.sh`](https://github.com/thatJavaNerd/scripts/blob/master/auto_pdf_images.sh)

Extracts all images from all PDFs in a given directory

####Usage

`$ auto_pdf_images.sh <dir>`

####Arguments

Name | Description
---- | -----------
`dir` | The directory to search for PDFs. Also the output directory

####Examples

```shell
# Extract all images from all PDFs in a directory called "pdfs/"
user@hostname:~$ auto_pdf_images.sh pdfs/
```
####Exit codes

Code | Description
---- | -----------
`0` | Exited normally

####Dependencies

- [`extr_pdf_imgs.sh`](https://github.com/thatJavaNerd/scripts/blob/master/extr_pdf_imgs.sh)

##[`backup.sh`](https://github.com/thatJavaNerd/scripts/blob/master/backup.sh)

Backs up (gzips) certain directories. If no directories are given, then the script will backup the following directories:

- `~/.config`
- `~/projects`
- `/etc/apache2/sites-available`
- `/opt/android-studio`
- `/opt/android-sdk`
- `/opt/scripts`
- `/var/www`


####Usage

`$ backup.sh <archive> <directory> [directories...] [-r | --restore]`

####Arguments

Name | Description
---- | -----------
`archive` | The file to create and gzip the directories into
`directory` | A directory to add to the archive
`directories...` | More directories to add to the archive
`restore` | Whether to restore the files instead of back them up (not currently functionng)

####Examples

```shell
# Backup the default list of directories to a file called "backup.tar.gz"
user@hostname:~$ backup.sh backup.tar.gz
# Backup the directories "dir1", "dir2", and "dir3" to a file called "backup.tar.gz"
user@hostname:~$ backup.sh backup.tar.gz dir1/ dir2/ dir3/
# (incubating) Restore the backup file "backup.tar.gz"
user@hostname:~$ backup.sh backup.tar.gz --restore
```
####Exit codes

Code | Description
---- | -----------
`0` | Exited normally
`1` | If a backup location was not specified


##[`cha2site.sh`](https://github.com/thatJavaNerd/scripts/blob/master/cha2site.sh)

Change the currently enabled Apache 2 virtual site. Disables all currently enabled sites, enables the given one, and reloads the `apache2` service.

####Usage

`$ cha2site.sh <site>`

####Arguments

Name | Description
---- | -----------
`site` | The name of the `.conf` file in `/etc/apache2/sites-available/`, without the `.conf` extension

####Examples

```shell
# Enable a virtual site called "mysite"
user@hostname:~$ cha2site.sh mysite
```
####Exit codes

Code | Description
---- | -----------
`0` | Exited normally
`1` | If the given site does not exist

####Dependencies

- [`apache2`](https://httpd.apache.org/)

##[`docgen.py`](https://github.com/thatJavaNerd/scripts/blob/master/docgen.py)

This script generates the README.md file you are reading right now by parsing JSON files in the [docgen/](https://github.com/thatJavaNerd/scripts/tree/master/docgen) directory

####Usage

`$ docgen.py`

####Examples

```shell
# Generate documentation for the scripts. Must be run in this project's root directory.
user@hostname:~$ docgen.py 
```
####Exit codes

Code | Description
---- | -----------
`0` | Exited normally
`1` | Unexpted exit

####Dependencies

- [`python3`](https://www.python.org/)

##[`extr_pdf_imgs.sh`](https://github.com/thatJavaNerd/scripts/blob/master/extr_pdf_imgs.sh)



####Usage

`$ extr_pdf_imgs.sh <pdf-name> <directory-name> <base-name>`

####Arguments

Name | Description
---- | -----------
`pdf-name` | The name of the PDF file to extract the images from
`directory-name` | The directory to extract (and make if it doesn't exist) the files into
`base-name` | The common base-name of every picture from the PDF

####Examples

```shell
# Extract all the images from "file.pdf" to "out/", all with a basename of "myprefix"
user@hostname:~$ extr_pdf_imgs.sh file.pdf out/ myprefix
```
####Exit codes

Code | Description
---- | -----------
`0` | Exited normally
`1` | If there were not 3 arguments specified

####Dependencies

- [`poppler-utils`](http://poppler.freedesktop.org/)

##[`imgext.sh`](https://github.com/thatJavaNerd/scripts/blob/master/imgext.sh)

Corrects the extensions of common internet media formats (png, jpg, gif, webm, svg) in a directory by looking at its MIME-type

####Usage

`$ imgext.sh <dir>`

####Arguments

Name | Description
---- | -----------
`dir` | The directory to scan and correct media in

####Examples

```shell
# Correct all file extensions in a directory called "my_images"
user@hostname:~$ imgext.sh my_images/
```
####Exit codes

Code | Description
---- | -----------
`0` | Exited normally


##[`new_chrome_ext.sh`](https://github.com/thatJavaNerd/scripts/blob/master/new_chrome_ext.sh)

Creates a template for a new Google Chrome extension. Currently a work in progress.

####Usage

`$ new_chrome_ext.sh`

####Examples

```shell
# Create a new template for a Chrome extension
user@hostname:~$ new_chrome_ext.sh 
```
####Exit codes

Code | Description
---- | -----------
`0` | Exited normally


##[`new_setup.sh`](https://github.com/thatJavaNerd/scripts/blob/master/new_setup.sh)

>Warning: This script requires to be run as root

Perform common fresh-install tasks (install and remove software, fonts, generate system config files, add PPAs, install ZSH, etc.)

####Usage

`# new_setup.sh [-a | --all] [-f | --fonts] [-b | --fstab] [-g | --git] [-h | --help] [-i | --install] [-p | --ppa] [-r | --remove] [-s | --settings] [-t | --terminator] [-z | --oh-my-zsh]`

####Arguments

Name | Description
---- | -----------
`all` | Do all of the things listed below
`fonts` | Installs [Source Code Pro](http://www.google.com/fonts/specimen/Source+Code+Pro) and [Powerline Ubuntu Mono](https://github.com/Lokaltog/powerline-fonts/tree/master/UbuntuMono)
`fstab` | Change boot-time partition mount options by modifying `/etc/fstab`. Uses my setup:<ul><li>`sda1`: MBR partition</li><li>`sda2`: Windows partition</li><li>`sda3`: "Storage" partition: an NTFS partition used by both Windows and Linux</li><li>`sda4`: Extended partition</li><ul><li>`sda5`: Linux partition</li><li>`sda6`: Swap partition</li></ul></ul>
`git` | Sets up git using `git config --global $setting`. Enables color (`color.ui true`), sets thedefault editor to `vim` (`core.editor vim`), sets the default push strategy to simple (`push.default simple`), sets the user's name to "Matthew Dean" (`user.name "Matthew Dean"`), and prompts for an email address for `user.email`.
`help` | Show a help message and exits
`install` | Installs `vim-gtk`, `curl`, `google-chrome-stable`, `terminator`, `keepassx`, `truecrypt`, `ubuntu-tweak`, `unity-tweak-tool`, `gnome-tweak-tool`, `tor-browser`, `sublime-text-installer`, `flashplugin-installer`, `vlc`, `rar`, `git`, `curl`, `zsh`, `tmux`, `python3-pip`, and `gimp`
`ppa` | Adds the following PPAs:

<ul><li>`webupd8team/java`</li><li>`keepassx/daily`</li><li>`tualatrix/ppa`</li><li>`stefansundin/truecrypt`</li><li>`webupd8team/tor-browser`</li><li>`webupd8team/sublime-text-3`</li></ul>Also adds the [Google Chrome repo](http://www.ubuntuupdates.org/ppa/google_chrome)
`remove` | Removes `unity-lens-shopping` and `gnome-orca`
`settings` | Disables error reporting messages to Canonical by setting `enabled=0` in `/etc/default/apport`
`terminator` | Change Terminator's default color scheme to Solarized Dark and applies Ubuntu Mono patched font (see `--fonts` to install)
`oh-my-zsh` | Installs [`oh-my-zsh`](https://github.com/robbyrussell/oh-my-zsh) and sets the theme to "agnoster"

####Examples

```shell
# Do all fresh-install tasks
hostname# new_setup.sh -a
# Only modify /etc/fstab
hostname# new_setup.sh --fstab
# Only install software
hostname# new_setup.sh --install
```
####Exit codes

Code | Description
---- | -----------
`0` | Exited normally
`1` | Various error occurred

####Dependencies

- [`apt-get`](https://wiki.debian.org/apt-get)
- [`wget`](https://www.gnu.org/software/wget/)

##[`new_setup_settings.sh`](https://github.com/thatJavaNerd/scripts/blob/master/new_setup_settings.sh)

Perform common fresh-install tasks that must be done while NOT running as root. It could be run as root, however, but the settings would not apply to the current user (what we actually want). This script:
 - Changes the window border buttons to be similar to Windows
 - Disables the Amazon and several other enabled-by-default Unity scopes
 - Sets a few favorites on Unity
 - Changes the shell to `zsh`
 - Clones my dotfiles repo on Bitbucket to the home directory of the current logged in user

####Usage

`$ new_setup_settings.sh`

####Examples

```shell
# Runs the settings
user@hostname:~$ new_setup_settings.sh 
```
####Exit codes

Code | Description
---- | -----------
`0` | Exited normally

####Dependencies

- [`gsettings`](https://developer.gnome.org/gio/2.39/gsettings-tool.html)
- [`git`](http://git-scm.com/)

##[`path.sh`](https://github.com/thatJavaNerd/scripts/blob/master/path.sh)

This script reads a file at `~/.path` and every directory (if it exists) to a `$PATH`-like variable. Lines that are empty or start with '#' are ignored. At the end of this script, the new path variable is echoed out for use in other scripts.

Sample usage:

```shell
newpath=$(path.sh)
if [ $? -eq 0 ]; then
    export PATH=$newpath
else
    # $newpath has the error message from path.sh
    echo $newpath
fi
```

####Usage

`$ path.sh`

####Examples

```shell
# Show the new path variable. Note that this is not actually applied to your current session
user@hostname:~$ path.sh 
```
####Exit codes

Code | Description
---- | -----------
`0` | Exited normally
`1` | The `~/.path` file does not exist
`2` | A directory in `~/.path` does not exist


##[`scramdir.sh`](https://github.com/thatJavaNerd/scripts/blob/master/scramdir.sh)

Replaces the basename (the name of the file without its extension) with a randomly generated alphanumeric string 7 characters long

####Usage

`$ scramdir.sh <folder> [-f | --force] [-q | --quiet] [-s | --simulate]`

####Arguments

Name | Description
---- | -----------
`folder` | The folder whose contents will have scrambled basenames after the execution of this script
`force` | Skip the prompt asking the user to confirm their actions
`quiet` | Suppresses output showing the new and old file names
`simulate` | Don't actually rename the files

####Examples

```shell
# Scramble a folder called "myfolder/"
user@hostname:~$ scramdir.sh myfolder/
```
####Exit codes

Code | Description
---- | -----------
`0` | Exited normally
`1` | The given directory does not exist


##[`verify.sh`](https://github.com/thatJavaNerd/scripts/blob/master/verify.sh)

>Warning: This script requires to be run as root

Verify that a file has not been modified since its original hashing.

This script creates a hash of a file in `~/.verify.sh/` where the file name is the given file and its contents is the SHA-512 sum of the original file. This command exits with a non-zero code if the stored hashes of the given files did not equal their just-calculated hashes.

####Usage

`# verify.sh <file> [files...] [-u | --update] [-h | --help]`

####Arguments

Name | Description
---- | -----------
`file` | A file to check
`files...` | A list of extra files to check. If one of these files does not match its hash, the entire script will exit with a non-zero exit code.
`update` | Forces updating the hashes of the given files
`help` | Shows a help message

####Examples

```shell
# Verify that a file called "file_one.txt" has not been modified since it's last hash. If no hash file exists, a new one will be created.
hostname# verify.sh file_one.txt
# Forces creating a new hash for a file called "file_one.txt".
hostname# verify.sh file_one.txt --update
# Verify the integrity of all three files mentioned. If a hash was not found for a file, one will be generated.
hostname# verify.sh file_one.txt file_two.txt file_three.txt
```
####Exit codes

Code | Description
---- | -----------
`0` | Exited normally
`1` | A hash did not match
`2` | If no files were given
`3` | If a given file did not exist

####Dependencies

- [`sha512sum`](https://www.gnu.org/software/coreutils/)

##[`yt2wav.sh`](https://github.com/thatJavaNerd/scripts/blob/master/yt2wav.sh)

Simple script to download a YouTube video and then extract its audio in the form of a wav file

####Usage

`$ yt2wav.sh <video>`

####Arguments

Name | Description
---- | -----------
`video` | The URL of the YouTube video to download

####Examples

```shell
# Download "Fortune Days" by The Glitch Mob
user@hostname:~$ yt2wav.sh https://www.youtube.com/watch?v=hbAUwi4D3Ew
```
####Exit codes

Code | Description
---- | -----------
`0` | Exited normally
`1` | youtube-dl was not installed
`2` | ffmpeg was not installed

####Dependencies

- [`youtube-dl`](https://rg3.github.io/youtube-dl/)
- [`ffmpeg`](https://www.ffmpeg.org/)

