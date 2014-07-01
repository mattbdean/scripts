My bash scripts
=======

A few scripts that I use. Nothing (too) special.

###[`andricon.sh`](https://github.com/thatJavaNerd/scripts/blob/master/andricon.sh)

This script uses [imagemagick](http://www.imagemagick.org/) to resize an image to fit the specification of Android "drawable" images.

###[`auto_pdf_images.sh`](https://github.com/thatJavaNerd/scripts/blob/master/auto_pdf_images.sh)

Extracts all images from all PDFs in a given directory

###[`backup.sh`](https://github.com/thatJavaNerd/scripts/blob/master/backup.sh)

Backs up (gzips) certain directories

###[`cha2site.sh`](https://github.com/thatJavaNerd/scripts/blob/master/cha2site.sh)

"Change Apache 2 virtual site"

Disables all previously enabled sites, enables the given site, and reload the `apache2` service

###[`extr_pdf_imgs.sh`](https://github.com/thatJavaNerd/scripts/blob/master/extr_pdf_imgs.sh)

Extract images from a PDF and put them into a folder with a common base name.

###[`imgext.sh`](https://github.com/thatJavaNerd/scripts/blob/master/imgext.sh)

Attempts to fix the extensions of image files such as jpg, png, gif, svg, and webm (yes I know webm is not an image) by looking at the MIME type of the file.

###[`new_chrome_ext.sh`](https://github.com/thatJavaNerd/scripts/blob/master/new_chrome_ext.sh)

Template for a new Google Chrome extension. Currently a work in progress.

###[`new_setup.sh`](https://github.com/thatJavaNerd/scripts/blob/master/new_setup.sh)

Perform common fresh-install tasks (install and remove software, fonts, generate system config files, add PPAs, install ZSH, etc.). Requires root access.

###[`new_setup_settings.sh`](https://github.com/thatJavaNerd/scripts/blob/master/new_setup_settings.sh)

Set user preferences and download my dotfiles. This is not included in `new_setup.sh` because it requires to NOT have root access

###[`path.sh`](https://github.com/thatJavaNerd/scripts/blob/master/path.sh)

This script reads a file at ~/.path and every directory (if it exists) to a $PATH-like
variable. Empty lines and ones that start with a '#' ar ignored. At the end of this
script, the new path variable is echoed out for use in other scripts.

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

####Exit codes:

 `1` - `~/.path` does not exist

 `2` - A directory in `~/.path` does not exist

###[`scramdir.sh`](https://github.com/thatJavaNerd/scripts/blob/master/scramdir.sh)

Scrambles the basename of all files in a directory to a random alphanumeric string

###[`verify.sh`](https://github.com/thatJavaNerd/scripts/blob/master/verify.sh)

Verify that a file has not been modified since its original hashing. Requires super-user access.

This script creates a hash of a file in `~/.verify.sh/` where the file name is the given file and its contents is the SHA-512 sum of the original file. This command exits with a non-zero code if the stored hashes of the given files did not equl their just-calculated hashes.

###[`yt2wav.sh`](https://github.com/thatJavaNerd/scripts/blob/master/yt2wav.sh)

Simple script that uses `youtube-dl` and `ffmpeg` to download extract the audio from a YouTube video
