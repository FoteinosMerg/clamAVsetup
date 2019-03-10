#!/bin/bash

echo

# Find OS
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    # CYGWIN*)    machine=Cygwin;;
    # MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# Install separately some prerequisites ----------------------------------------


if [ ${machine} = "Linux" ]; then
	sudo apt-get update

	packages=(gcc clang build-essential openssl libssl-dev libcurl4-openssl-dev zlib1g-dev libpng-dev libxml2-dev libjson-c-dev libbz2-dev libpcre3-dev ncurses-dev)
	already_installed=()
	for package in "${packages[@]}"
	do
	  dpkg -s $package >/dev/null 2>&1 && {
	      echo "*** $package" already installed
	  } || {
	      sudo apt-get install -y $package
	      already_installed+=( $package )
	  }
	done

	# Installation of main packages ------------------------------------------------

	sudo apt-get install clamav clamav-freshclam #heirloom-mailx



# freshclam configuration ------------------------------------------------------

sudo mkdir -p /etc/clamav
if [ ! -f /etc/clamav/freshclam.conf ]; then
    sudo cp freshclam.conf /etc/clamav/freshclam.conf
fi

# /etc/init.d/clamav-freshclam start
sudo service clamav-freshclam start
sudo systemctl daemon-reload

# Display info about freshclam update (manual update with: freshclam -v)
ps -ef | grep fresh | grep clam
grep -i check /etc/clamav/freshclam.conf


# Databases creation -----------------------------------------------------------

sudo mkdir -p /var/lib/clamav

# Users and user-privileges cnfiguration ---------------------------------------

# Delete group if it already exists
sudo sed -i '/clamav/d' /etc/group
# Create the clamav group
sudo groupadd clamav
# Create the clamav user account
sudo useradd -g clamav -s /bin/false -c "clamAv" clamav
# Set user ownership for the database directory
sudo chown -R clamav:clamav /usr/local/share/clamav

# Download and update signature databases --------------------------------------
sudo ldconfig
sudo freshclam

elif [ ${machine} = "Mac" ]; then
	which -s brew
	if [[ $? != 0 ]] ; then
	    # Install Homebrew
	    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
	    echo Homebrew is installed. Upgrade
	    brew update
	fi
	brew reinstall -f clamav


	# freshclam configuration ------------------------------------------------------
	# cd /usr/local/etc/clamav
	# cp /usr/local/etc/clamav/freshclam.conf.sample /usr/local/etc/clamav/freshclam.conf
	cp freshclam.conf /usr/local/etc/clamav/freshclam.conf
	# sed -i '' 's/Example/#Example/g' /usr/local/etc/clamav/freshclam.conf
	# sed -i '' 's/#DatabaseDirectory/DatabaseDirectory/g' /usr/local/etc/clamav/freshclam.conf

	sudo mkdir -p /var/log/clamav

	# Display info about freshclam update (manual update with: freshclam -v)
	ps -ef | grep fresh | grep clam
	grep -i check  /usr/local/etc/clamav/freshclam.conf

	# Databases creation -----------------------------------------------------------

	sudo mkdir -p /var/lib/clamav
	sudo chown -R clamav:wheel /var/log/clamav/

	# Users and user-privileges cnfiguration ---------------------------------------

	# Delete group if it already exists
	sudo dscl . -create /Groups/clamav
	# Create the clamav user account
	sudo dscl . -create /Users/clamav
	# Set user ownership for the database directory
	# bug: group cannot be assigned
	sudo chown -R clamav: /usr/local/share/clamav

	# Download and update signature databases --------------------------------------
	sudo update_dyld_shared_cache
	sudo freshclam
fi


sleep .5
echo "-------------------------------------------------------------------------"
which clamscan
which freshclam
echo "-------------------------------------------------------------------------"
sleep .5


