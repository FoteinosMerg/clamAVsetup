# #!/bin/bash

echo

# Find OS ----------------------------------------------------------------------

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN: ${unameOut}"
esac

# Start installation process ---------------------------------------------------

if [ ${machine} = "Linux" ]; then

	sudo apt-get update

  # Install separately prerequisites -------------------------------------------

	packages=(gcc
            clang
            build-essential
            openssl
            libssl-dev
            libcurl4-openssl-dev
            zlib1g-dev
            libpng-dev
            libxml2-dev
            libjson-c-dev
            libbz2-dev
            libpcre3-dev
            ncurses-dev)
	already_installed=()
  echo
	for package in "${packages[@]}"
	do
	  dpkg -s $package >/dev/null 2>&1 && {
	      echo " * $package already installed"
	  } || {
	      sudo apt-get install -y $package
	      already_installed+=( $package )
	  }
	done
  echo

  # Download and install unit testing dependencies
  sudo apt-get install valgrind check

  # Main installation ----------------------------------------------------------

  ./clamav-download.sh
  cd clamav-latest
  ./configure --enable-check

  sudo make uninstall
  make -j2                                                # Compile ClamAV
  make check                                              # Run unit tests
  sudo cp freshclam.conf /usr/local/etc/                  # freshclam configuration
  sudo make install                                       # Install ClamAV
  sudo mkdir -p /usr/local/share/clamav

  sudo mkdir -p /var/lib/clamav                           # Database dir creation
  sudo ldconfig                                           # Download signature database

  # Users and user-privileges cnfiguration -------------------------------------

  sudo sed -i '/clamav/d' /etc/group                      # Delete group if it already exists
  sudo groupadd clamav                                    # Create the clamav group
  sudo useradd -g clamav -s /bin/false -c "clamAv" clamav # Create the clamav user account
  sudo chown -R clamav:clamav /usr/local/share/clamav     # Set user ownership for the database directory

  # Reload units for clamav-freshclam.service
  sudo service clamav-freshclam start
  sudo systemctl daemon-reload

elif [ ${machine} = "Mac" ]; then
	which -s brew
	if [[ $? != 0 ]] ; then
	    # Install homebrew
	    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
	    echo "Homebrew is installed. Upgrade"
	    brew update
	fi

  # Install prerequisites ------------------------------------------------------
  xcode-select --install
  brew install pcre2 openssl json-c
  brew install valgrind check

  # Main installation ----------------------------------------------------------
	# brew reinstall -f clamav
	# sudo cp freshclam.conf /usr/local/etc/
  ./clamav-download.sh
  cd clamav-latest
  ./configure --with-openssl=/usr/local/Cellar/openssl/1.0.2l --with-libjson=yes --enable-check

  make -j2                                                # Compile
  make check                                              # Run unit tests
  sudo cp freshclam.conf /usr/local/etc/
  make install
  sudo mkdir -p /usr/local/share/clamav

	sudo mkdir -p /var/lib/clamav                           # Database dir creation
  sudo update_dyld_shared_cache                           # Download signature database


	# Users and user-privileges cnfiguration -------------------------------------

  sudo chown -R clamav:wheel /var/log/clamav/
	sudo dscl . -create /Groups/clamav                      # Delete group if it already exists
	sudo dscl . -create /Users/clamav                       # Create the clamav user account
  sudo mkdir -p /usr/local/share/clamav
	sudo chown -R clamav: /usr/local/share/clamav           # Set user ownership for the db dir

else
  echo "OS unknown. Exiting"
  exit 2
fi

sudo rm -rf clamav-latest #(does not work)               # Delete installation folder

# Update database (final check) ------------------------------------------------

echo "-------------------------------------------------------------------------"
echo "DATABASE UPDATE"
echo
sudo freshclam --verbose # final check

sleep .5
echo "-------------------------------------------------------------------------"
clamscan -V
echo
which clamscan
which freshclam
echo
echo "freshclam configuration at: /usr/local/etc/"
echo "-------------------------------------------------------------------------"
sleep .5

exit 0
