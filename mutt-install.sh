#!/bin/bash

# USAGE:
# ./mutt-install <EMAIL_FROM> <EMAIL_PASSWORD> <COMPUTER>
#
# mutt USAGE:
# echo <BODY_TEXT> | mutt -s <SUBJECT> <EMAIL_TO> -a <ATTACHED_FILE>

sudo apt-get purge --auto-remove mutt -y
sudo apt-get update
sudo apt-get install mutt -y

# mutt gmail config
USERNAME=$1
EMAIL_FROM="$USERNAME@gmail.com"
EMAIL_PASSWORD=$2
SMTP_URL="$USERNAME@smtp.gmail.com:587"
COMPUTER=$3
SET_FOLDER="imap.gmail.com:993"
sudo cp .muttrc ~/.muttrc
sudo chmod 600 ~/.muttrc
sudo sed -i "s/EMAIL_FROM/$EMAIL_FROM/g" ~/.muttrc
sudo sed -i "s/EMAIL_PASSWORD/$EMAIL_PASSWORD/g" ~/.muttrc
sudo sed -i "s/SMTP_URL/$SMTP_URL/g" ~/.muttrc
sudo sed -i "s/COMPUTER/$COMPUTER/g" ~/.muttrc
sudo sed -i "s/SET_FOLDER/$SET_FOLDER/g" ~/.muttrc

sleep .5
echo "-------------------------------------------------------------------------"
which mutt
echo ""
echo "Global configuration at:"
sudo ls -rtlha --ignore=*.d /etc | grep Mutt
echo ""
echo "User specific configuration at:"
sudo ls -rtlha ~ | grep mutt
echo "-------------------------------------------------------------------------"

# echo "_test attach" | mutt -s "_subject" foteinosmerg@protonmail.com -a .muttrc
