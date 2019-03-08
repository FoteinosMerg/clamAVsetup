#!/bin/bash

sudo apt-get install ssmtp
sudo vim /etc/ssmtp/ssmtp.conf
sudo cp ssmtp.conf /etc/ssmtp/ssmtp.conf

# Restric access to regular users
sudo chmod 0600 /etc/ssmtp/ssmtp.conf
