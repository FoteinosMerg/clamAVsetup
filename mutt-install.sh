#!/bin/bash
sudo apt-get purge --auto-remove mutt -y
sudo apt-get update
sudo apt-get install mutt -y

sudo mv .muttrc ~/.muttrc
sudo chmod 600 ~/.muttrc
# nano ~/.muttrc

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
sleep .5

# echo "_test attach" | mutt -s "_subject" foteinosmerg@protonmail.com -a .muttrc
