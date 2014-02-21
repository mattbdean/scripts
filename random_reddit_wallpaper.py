#!/usr/bin/env python3

import praw
import os
from subprocess import call, CalledProcessError
import urllib.request
import sys

download_location = "/media/storage/Pictures/Wallpapers/From Reddit/"

r = praw.Reddit(user_agent="Random Wallpaper Grabber by /u/WHOWANTSAKOOKIE")
sumbissions = r.get_subreddit('wallpapers').get_top_from_week(limit=1)

for post in sumbissions:
	url = post.url
	extension = url[url.rfind('.'):]
	if extension:
		filename = url[url.rfind('/') + 1:]
		# The URL has a valid extension, try to download it
		download = download_location + filename
		print("Downloading {:s} (from /r/{:s}) to {:s}".format(url, post.subreddit.display_name, download))
		urllib.request.urlretrieve(url, download)
		os.system("gsettings set org.gnome.desktop.background picture-uri \"file:///" + download + "\"")
		sys.exit(0)
