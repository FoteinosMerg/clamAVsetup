#!/bin/bash
#
# USAGE:
# ./mutt-install <ID> <USERNAME> <PASSWORD> <SERVER>

# Find OS ----------------------------------------------------------------------

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    # CYGWIN*)    machine=Cygwin;;
    # MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN: ${unameOut}"
esac

# Install mutt -----------------------------------------------------------------

if [ ${machine} = "Linux" ]; then
  sudo apt-get purge --auto-remove mutt -y
  sudo apt-get update
  sudo apt-get install mutt -y
elif [ ${machine} = "Mac" ]; then
  # /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  which -s brew
  if [[ $? != 0 ]] ; then
      # Install homebrew
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
      echo "Homebrew is installed. Upgrade"
      brew update
  fi
  brew uninstall -f mutt && brew install mutt

else
  echo "OS unknown. Exiting"
  exit 2
fi

# mutt config ------------------------------------------------------------------

ID=$1
USERNAME=$2
PASSWORD=$3
SERVER=$4

# Backup possibly pre-existing .muttrc file
if [ -f ~/.muttrc ]; then
    sudo mv ~/.muttrc ~/.muttrc_backup-$(sudo date +"%Y-%m-%d_%H-%M-%S")
fi
sudo cp .muttrc ~/.muttrc
sudo chmod 600 ~/.muttrc

# Write config
if [ ${machine} = "Linux" ]; then
  sudo sed -i "s/ID/$ID/g" ~/.muttrc
  sudo sed -i "s/USERNAME/$USERNAME/g" ~/.muttrc
  sudo sed -i "s/PASSWORD/$PASSWORD/g" ~/.muttrc
  sudo sed -i "s/SERVER/$SERVER/g" ~/.muttrc
else # MacOS
  sudo sed -i '' "s/ID/$ID/g" ~/.muttrc
  sudo sed -i '' "s/USERNAME/$USERNAME/g" ~/.muttrc
  sudo sed -i '' "s/PASSWORD/$PASSWORD/g" ~/.muttrc
  sudo sed -i '' "s/SERVER/$SERVER/g" ~/.muttrc
fi

# Print info about successfull installation and configuration ------------------
sleep .5
echo "-------------------------------------------------------------------------"
which mutt
echo ""
echo "User specific configuration at:"
sudo ls -rtlha ~ | grep -w .muttrc
echo "-------------------------------------------------------------------------"
sleep .5

exit 0
