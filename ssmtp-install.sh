#!/bin/bash
sudo apt-get purge --auto-remove ssmtp -y
sudo apt-get update
sudo apt-get install ssmtp -y
sudo apt-get install bsd-mailx  -y
sudo vim /etc/ssmtp/ssmtp.conf
sudo cp ssmtp.conf /etc/ssmtp/ssmtp.conf
sudo echo "root:foteinosmerg@gmail.com:smtp.gmail.com:587" > revaliases
sudo mv revaliases /etc/ssmtp/revaliases

# Restric access to regular users
# sudo chmod 777 /etc/ssmtp /etc/ssmtp/*
sudo chmod 0600 /etc/ssmtp/ssmtp.conf
# Make file readable by `mail`
sudo chown root:mail /etc/ssmtp/ssmtp.conf
sudo chown root:send-mail /etc/ssmtp/ssmtp.conf

# USAGE
# echo "test" | mail -v -s "TEST" foteinosmerg@protonmail.com
# ssmtp foteinosmerg@protonmail.com < package-lock.json
