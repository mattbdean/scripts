#!/bin/bash

##### MISC SETTINGS #####
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close' # Put window buttons on right
# Disable shopping lenses
gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"
# Set the favorites
gsettings set com.canonical.Unity.Launcher favorites "['application://google-chrome.desktop', 'application://terminator.desktop', 'application://sublime-text.desktop', 'application://nautilus.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"
# Use Zsh
chsh $(whoami) -s $(which zsh)

##### DOTFILES #####
echo "Getting dotfiles..."
dotfiles_dir=/tmp/dotfiles

rm -rf $dotfiles_dir
git clone https://bitbucket.org/thatJavaNerd/dotfiles $dotfiles_dir

# http://unix.stackexchange.com/a/6397
shopt -s dotglob nullglob
mv $dotfiles_dir/* ~

rm -rf ~/.git
