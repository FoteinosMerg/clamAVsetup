#!/bin/bash

#
# After running this script, a clamav-latest directory will have been created
# inside the current working directory. Enter it to build the
# latest versions of ClamAV
#

wget -r --no-parent -A 'clamav-*.tar.gz' -P . https://www.clamav.net/downloads/
mv www.clamav.net/downloads/production/clamav-*.tar.gz ./clamav-latest.tar.gz
tar -xzf clamav-latest.tar.gz
mkdir -p clamav-latest && tar -xzf clamav-latest.tar.gz -C clamav-latest --strip-components 1
rm -rf clamav-latest.tar.gz

# Delete all directories except for clamav-latest
find . -type 'd' | grep -v "clamav-latest" | xargs sudo rm -rf

echo
echo "Download complete"
echo "Enter clamav-latest to install the latest version of ClamAV"
exit 0
