#!/bin/bash

sudo apt-get update

# Install separately some prerequisites ----------------------------------------

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
sleep .5
echo "-------------------------------------------------------------------------"
which clamscan
which freshclam
echo "-------------------------------------------------------------------------"
sleep .5

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

if [ -d /usr/local/share/clamav ]
then
    sudo rm -rf /usr/local/share/clamav
fi
sudo mkdir /usr/local/share/clamav

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
