#!/bin/bash

source core.sh

TRUE=1
FALSE=0

help() {
	phelp $0
	exit 0
}

## Tests if a package is installed
## $1: The package to test
packageInstalled() {
	dpkg-query -l "$1" &>/dev/null
}


## $1: The file to use
## $2: The string to find
## $3: The string to replace it with
findAndReplace() {
	cat "$1" | sed -e "s,$2,$3," > "$1.new"
	mv "$1.new" "$1"
}

## Returns the absolute path of the user's home directory
userHome() {
	echo "/home/$SUDO_USER"
}

action() {
	if [[ "${ACTIONS[$1]}" == "$TRUE" ]] || [[ "${ACTIONS[all]}" == "$TRUE" ]]; then
		echo $TRUE
	else
		echo $FALSE
	fi
}

statusMessage() {
	case "$?" in
		0)
			echo "OK"
			;;
		1)
			echo "FAIL"
			;;
		*)
			echo "(exit code $?)"
			;;
			
	esac
}

## Installs a font.
## $1 The URL of the font to download and install
font() {
	if [[ -z "$1" ]]; then
		perror "No font given."
		exit 1
	fi
	FONT_DIR="/usr/share/fonts/truetype/custom"
	# Download the font
	mkdir -p $FONT_DIR
	wget "$1" -P $FONT_DIR
}

## Updates the font cache
font_done() {
	echo -n "Updating font cache... "
	fc-cache -f
	statusMessage
}

declare -A ACTIONS

# Read parameters
while test $# -gt 0; do
	case "$1" in
		-h|--help)
			help
			exit 0
			;;
		-a|--all)
			ACTIONS[all]=$TRUE
			shift
			;;
		-b|--fstab)
			ACTIONS[fstab]=$TRUE
			shift
			;;
		-g|--git)
			ACTIONS[git]=$TRUE
			shift
			;;
		-i|--install)
			ACTIONS[install]=$TRUE
			shift
			;;
		-p|--ppa)
			ACTIONS[ppa]=$TRUE
			shift
			;;
		-r|--remove)
			ACTIONS[remove]=$TRUE
			shift
			;;
		-s|--settings)
			ACTIONS[settings]=$TRUE
			shift
			;;
		-f|--fonts)
			ACTIONS[fonts]=$TRUE
			shift
			;;
		-t|--terminator)
			ACTIONS[terminator]=$TRUE
			shift
			;;
		-z|--oh-my-zsh)
			ACTIONS[oh-my-zsh]=$TRUE
			shift
	esac
done

##### SET UP PPAs #####
if [[ $(action "ppa") == "$TRUE" ]]; then
	SOURCES_HOME=/etc/apt/sources.list.d

	ppa_list=("webupd8team/java" "keepassx/daily" "tualatrix/ppa" "stefansundin/truecrypt" "webupd8team/tor-browser" "webupd8team/sublime-text-3")

	for ppa in "${ppa_list[@]}"; do
		
		# Search for the PPA in /etc/apt/sources.list.d/
		found=$FALSE
		for f in $SOURCES_HOME/*.list; do
			filename="${f##*/}"
			filename=$(basename $filename .list)
			filename=${filename/-/\/}

			if [[ $filename == $ppa* ]]; then
				found=$TRUE
			fi
		done
		
		if [[ $found == $FALSE ]]; then
			echo -n "Adding PPA ppa:${ppa}... "
			add-apt-repository "ppa:${ppa}" -y &>/dev/null
			statusMessage
		fi
	done
	
	# Google Chrome
	chrome_list=$SOURCES_HOME/google.list
	
	if [[ ! -f $chrome_list ]]; then
		echo -n "Adding Google Chrome sig: "
		wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
		echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> $chrome_list
	fi

	echo -n "Updating package list... "
	apt-get update &>/dev/null
	statusMessage
	echo -n "Upgrading packages... "
	apt-get upgrade &>/dev/null
	statusMessage
fi


##### REMOVE SOFTWARE #####
if [[ $(action "remove") == "$TRUE" ]]; then
	remove_list=("unity-lens-shopping" "gnome-orca")
	for remove in "${remove_list[@]}"; do
		echo -n "Removing $remove... "
		if packageInstalled "$remove"; then
			apt-get remove --purge "$remove" -y &>/dev/null
			statusMessage
		fi
	done

	echo -n "Autoremoving... "
	apt-get autoremove -y &>/dev/null
	statusMessage
fi

##### INSTALL NEW SOFTWARE #####
if [[ $(action "install" true) == "$TRUE" ]]; then
	install_list=("vim-gtk" "curl" "google-chrome-stable" "terminator" "keepassx" "truecrypt" "ubuntu-tweak" "unity-tweak-tool" "gnome-tweak-tool" \
		"tor-browser" "sublime-text-installer" "flashplugin-installer" "vlc" "rar" "git" "curl" "zsh" "tmux" "python3-pip" "gimp")

	for install in "${install_list[@]}"; do
		# Only call apt-get if we have to
		if ! packageInstalled "$install"; then
			echo -n "Installing $install... "
			apt-get install $install -y #&>/dev/null
			statusMessage
		fi
	done

	# Don't redirect the output because we need to accept agreements
	apt-get install ubuntu-restricted-extras -y
	apt-get install oracle-java7-installer -y
	apt-get install oracle-java7-set-default -y

	pip3 install praw

	# Fix Sublime Text 3 permissions
	chmod +x /opt/sublime_text/sublime_text
	chmod +x /opt/sublime_text/plugin_host
fi

##### OH-MY-ZSH #####
if [[ $(action "oh-my-zsh") == "$TRUE" ]]; then
	wget "https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
	# Prevent Zsh from running
	findAndReplace install.sh "/usr/bin/env zsh" "exit"
	sh install.sh
	rm install.sh
	chsh -s "$(which zsh)"
	# Set the theme to agnoster
	findAndReplace "$(userHome)/.zshrc" "ZSH_THEME=\"robbyrussell\"" "ZSH_THEME=\"agnoster\""


	# Change zsh permissions, currently owned by root, change them to $SUPER_USER
	find "$(userHome)" -maxdepth 1 -name "*zsh*" -exec chown -R "$SUDO_USER":"$(id -g -n "$SUDO_USER")" "{}" \;
fi

##### GIT #####
if [[ $(action "git") == "$TRUE" ]]; then
	echo "Configuring Git"
	git config --global color.ui true
	git config --global core.editor vim
	git config --global push.default simple
	git config --global user.name "Matthew Dean"
	echo "Enter your Git email:"
	read email
	if [[ ! -z "$email" ]]; then
		git config --global user.email "$email"
	else
		echo "No email entered, skipping..."
	fi
fi

##### MISC SETTINGS #####
if [[ $(action "settings") == "$TRUE" ]]; then
	# Disable error reporting to Canonical
	findAndReplace /etc/default/apport "enabled=1" "enabled=0"

	echo "Run new_setup_settings.sh for gsettings changes"
fi

##### FONTS #####
if [[ $(action "fonts") == "$TRUE" ]]; then
	font "http://ff.static.1001fonts.net/s/o/source-code-pro.regular.ttf"
	font "https://raw.github.com/Lokaltog/powerline-fonts/master/UbuntuMono/Ubuntu%20Mono%20derivative%20Powerline.ttf"

	font_done
fi

##### FSTAB #####
if [[ $(action "fstab") == "$TRUE" ]]; then
	cat << EOF > "/etc/fstab"
/dev/sda2 /media/win ntfs-3g nosuid,nodev,nofail,x-gvfs-show,x-gvfs-name=Windows 0 0 # Windows
/dev/sda4 /media/storage ntfs-3g nosuid,nodev,nofail,x-gvfs-show,x-gvfs-name=Storage 0 0 # Storage
/dev/disk/by-uuid/BA021B21021AE1E5 /mnt/BA021B21021AE1E5 auto nosuid,nodev,nofail,noauto 0 0 # SYSTEM
EOF
fi

##### TERMINATOR #####
if [[ $(action "terminator") == "$TRUE" ]]; then
	# Terminator preferences for Solarized Dark and Light
	# Taken from https://github.com/ghuntley/terminator-solarized/blob/master/config
	mkdir -p "$(userHome)/.config/terminator"
	cat << EOF > "$(userHome)/.config/terminator/config"

[global_config]
  title_transmit_bg_color = "#d30102"
  focus = system
[keybindings]
[profiles]
  [[default]]
    use_system_font = False
    font = Ubuntu Mono derivative Powerline 12
    background_image = None
    # Solarized Dark
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#002b36:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
    foreground_color = "#eee8d5"
    background_color = "#002b36"
    cursor_color = "#eee8d5"

  [[solarized-light]]
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#002b36:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
    background_color = "#eee8d5"
    foreground_color = "#002b36"
    cursor_color = "#002b36"

[layouts]
  [[default]]
    [[[child1]]]
      type = Terminal
      parent = window0
      profile = solarized-dark
    [[[window0]]]
      type = Window
      parent = ""
[plugins]
EOF
fi
