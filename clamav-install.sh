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

# Install general prerequisites ------------------------------------------------

# sudo apt-get update
#
# packages=(gcc clang build-essential openssl libssl-dev libcurl4-openssl-dev zlib1g-dev libpng-dev libxml2-dev libjson-c-dev libbz2-dev libpcre3-dev ncurses-dev)
# already_installed=()
# for package in "${packages[@]}"
# do
#   dpkg -s $package >/dev/null 2>&1 && {
#       echo "*** $package" already installed
#   } || {
#       sudo apt-get install -y $package
#       already_installed+=( $package )
#
#   }
# done
#
# # Download and install unit testing dependencies
# sudo apt-get install valgrind check

# Installation -----------------------------------------------------------------

# ./configure --enable-check
#
# # Compile ClamAV
# make -j2
#
# # Run unit tests
# make check
#
# # Install ClamAV
# sudo make install
#
# # Check if .conf.sample files have indeed created inside /usr/local/etc
# # test -e /usr/local/etc/clamd.conf.sample && echo clamd.conf.sample created || echo clamd.conf.sample NOT created
# sudo cp /usr/local/etc/clamd.conf.sample /usr/local/etc/clamd.conf
# # test -e /usr/local/etc/freshclam.conf.sample && echo freshclam.conf.sample created || echo freshclam.conf.sample NOT created
# sudo cp /usr/local/etc/freshclam.conf.sample /usr/local/etc/freshclam.conf
#
# # Create directories for putting reports and infected files
#
# if [ -d ../INFECTED ]
# then
#     sudo rm -rf ../INFECTED
# fi
# sudo mkdir ../INFECTED
#
# if [ -d ../REPORTS ]
# then
#     sudo rm -rf ../REPORTS
# fi
# sudo mkdir ../REPORTS

# First-time configuration -----------------------------------------------------

# freshclam config
# sudo sed -i 's/Example/# Example/g' /usr/local/etc/freshclam.conf
# sudo sed -i 's/## # Example/## Example/g' /usr/local/etc/clamd.conf
# sudo sed -i 's/#LogTime/LogTime/g' /usr/local/etc/freshclam.conf
# sudo sed -i 's/#LogRotate/LogRotate/g' /usr/local/etc/freshclam.conf
# sudo sed -i '/#NotifyClamd/c\NotifyClamd /usr/local/etc/clamd.conf' /usr/local/etc/freshclam.conf
# sudo sed -i 's/#DatabaseOwner/DatabaseOwner/g' /usr/local/etc/freshclam.conf
#
# # clamd config (for higher performance)
# sudo sed -i 's/Example/# Example/g' /usr/local/etc/clamd.conf
# sudo sed -i 's/## # Example/## Example/g' /usr/local/etc/clamd.conf
# # sudo sed -i 's/#TCPSocket /TCPSocket /g' /usr/local/etc/clamd.conf
# sudo sed -i 's/#LogTime/LogTime/g' /usr/local/etc/clamd.conf
# sudo sed -i 's/#LogClean/LogClean/g' /usr/local/etc/clamd.conf
# sudo sed -i 's/#LogRotate/LogRotate/g' /usr/local/etc/clamd.conf
# sudo sed -i 's/#User/User/g' /usr/local/etc/clamd.conf
# sudo sed -i 's/#ScanOnAccess/ScanOnAccess/g' /usr/local/etc/clamd.conf
# sudo sed -i 's/#OnAccessIncludePath/OnAccessIncludePath/g' /usr/local/etc/clamd.conf
# sudo sed -i 's/#OnAccessExcludePath/OnAccessExcludePath/g' /usr/local/etc/clamd.conf
# sudo sed -i 's/#OnAccessPrevention/OnAccessPrevention/g' /usr/local/etc/clamd.conf


# Databases creation -----------------------------------------------------------

if [ -d /usr/local/share/clamav ]
then
    sudo rm -rf /usr/local/share/clamav
fi
sudo mkdir /usr/local/share/clamav

# Users and user-privileges cnfiguration ---------------------------------------

# # Delete group if it already exists
# sudo sed -i '/clamav/d' /etc/group
# # Create the clamav group
# sudo groupadd clamav
# # Create the clamav user account
# sudo useradd -g clamav -s /bin/false -c "clamAv" clamav
# # Set user ownership for the database directory
# sudo chown -R clamav:clamav /usr/local/share/clamav
#
# # Download and update signature databases --------------------------------------
# sudo ldconfig
# sudo freshclam
#
# # Check installed versions -----------------------------------------------------
# which clamscan
# which freshclam
