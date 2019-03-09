#!/bin/bash

# USAGE:
# ./mutt-install <EMAIL_FROM> <EMAIL_PASSWORD> <SERVER> <ID>
#
# mutt USAGE:
# echo <BODY_TEXT> | mutt -s <SUBJECT> <EMAIL_TO> -a <ATTACHED_FILE>

# Find OS
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    # CYGWIN*)    machine=Cygwin;;
    # MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
machine=${machine}

# Install mutt
if [ machine=="Linux" ]; then
  sudo apt-get purge --auto-remove mutt -y
  sudo apt-get update
  sudo apt-get install mutt -y
elif [ machine=="Mac" ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew uninstall -f mutt
  brew install mutt
else
  echo "OS unknown"
  exit 0
fi

# mutt gmail config
EMAIL_FROM=$1
_USERNAME=$(echo $1 | cut -d@ -f1)
EMAIL_PASSWORD=$2
SERVER=$3 # mail.riseup.net
ID=$4
# SET_FOLDER="imap.gmail.com:993"
sudo cp .muttrc ~/.muttrc
sudo chmod 600 ~/.muttrc
sudo sed -i "s/ID/$ID/g" ~/.muttrc
sudo sed -i "s/USERNAME/$_USERNAME/g" ~/.muttrc
sudo sed -i "s/EMAIL_FROM/$EMAIL_FROM/g" ~/.muttrc
sudo sed -i "s/SERVER/$SERVER/g" ~/.muttrc
sudo sed -i "s/EMAIL_PASSWORD/$EMAIL_PASSWORD/g" ~/.muttrc

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
