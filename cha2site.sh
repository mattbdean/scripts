#!/bin/bash

source $(dirname $(readlink -f $0))/core.sh

site=$1

if [ ! -f "/etc/apache2/sites-available/$site.conf" ]; then
	perror "Site does not exist: $site"
	exit 1
fi

# Disable all previously enabled websites
for website in /etc/apache2/sites-enabled/*.conf; do
	if [ -f $website ]; then
		sudo a2dissite $(basename $website)
	fi
done

# Enable the wanted website
sudo a2ensite $site

# Reload Apache
sudo service apache2 reload

