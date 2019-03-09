#!/bin/bash

# USAGE
# setup.sh <EMAIL_USERNAME> <EMAIL_PASSWORD> <COMPUTER>

EMAIL_USERNAME=$1
EMAIL_PASSWORD=$2
COMPUTER=$3

# ClamAV installation and configuration ----------------------------------------

sudo ./clamav-install.sh

# Report configuration ---------------------------------------------------------

sudo ./mutt-install.sh $EMAIL_USERNAME $EMAIL_PASSWORD $COMPUTER

# TEST
#
# ./clamav-daily <DIRTOSCAN>
#
