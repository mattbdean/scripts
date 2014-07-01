#!/bin/bash

# Test for null parameters
if [[ -f "/etc/apache2/sites-available/$1" ]]; then
	echo No new website given.
	exit 1
fi

# Disable all previously enabled websites
for website in /etc/apache2/sites-enabled/*.conf; do
	if [[ -f $website ]]; then
		sudo a2dissite $(basename $website)
	fi
done

# Enable the wanted website
sudo a2ensite $1

# Reload Apache
sudo service apache2 reload

