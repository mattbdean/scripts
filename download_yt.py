#!/usr/bin/env python3

import argparse
import os
import os.path
import youtube_dl
import stagger
from stagger.id3 import *
from pprint import pprint
from glob import glob

class Log(object):
    def debug(self, msg):
        print(msg)
    def warning(self, msg):
        print(msg)
    def error(self, msg):
        print(msg)

def main(url):
    out_dir = "_downloads"
    ytdl_opts = {
        "format": "bestaudio/best",
        "postprocessors": [{
            "key": "FFmpegExtractAudio",
            "preferredcodec": "mp3"
        }],
        "logger": Log(),
        "outtmpl": out_dir + "/%(title)s.%(ext)s"
    }
    with youtube_dl.YoutubeDL(ytdl_opts) as ytdl:
        ytdl.download([url])

    # List of characters that separate a name and title. An empty string is
    # given as a fallback so that the title is just the basename of the file.
    separators = [": ", " - ", ""]
    os.chdir(out_dir)
    for f in glob("*.mp3"):
        apply_tags(f, separators)
    
def apply_tags(fname, separators):
    tag = stagger.read_tag(fname)
    bname = os.path.splitext(os.path.basename(fname))[0]

    # Assume the title is in the format "$author $separator $title"
    title = bname
    artist = ""
    for sep in separators:
        if sep in bname:
            parts = bname.split(sep)
            artist = parts[0]
            title = parts[1]
            break

    # Assign ID3 tags
    tag[TIT2] = title
    tag[TPE1] = artist
    print("Tagging {} as '{}' by '{}'".format(fname, title, artist))
    tag.write()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Download and auto-tag music from YouTube")
    parser.add_argument("url", type=str, help="what to download from")
    args = parser.parse_args()
    main(args.url)

