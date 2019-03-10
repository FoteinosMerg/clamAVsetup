#!/bin/bash

# USAGE
#./clam-report.sh <DIRTOSCAN> <EMAIL_TO>

sudo freshclam -v

# sudo mkdir -p logs
touch clamav-$(sudo date +'%Y-%m-%d').log
LOGFILE="clamav-$(sudo date +'%Y-%m-%d').log" #"/var/log/clamav/clamav-$(date +'%Y-%m-%d').log";
EMAIL_MSG="Please see the log file attached.";
DIRTOSCAN=$1;
EMAIL_TO=$2

# Update ClamAV database
echo "Looking for ClamAV database updates...";
freshclam --quiet;

TODAY=$(date +%u);

# if [ "$TODAY" == "6" ];then
#  echo "Starting a full weekend scan.";
#
#  # be nice to others while scanning the entire root
#  sudo nice -n5 clamscan -ri / --exclude-dir=/sys/ &>"$LOGFILE";
# else
#  DIRSIZE=$(du -sh "$DIRTOSCAN" 2>/dev/null | cut -f1);
#
#  echo "Starting a daily scan of "$DIRTOSCAN" directory.
#  Amount of data to be scanned is "$DIRSIZE".";
#
#  sudo clamscan -ri "$DIRTOSCAN" &>"$LOGFILE";
# fi

DIRSIZE=$(du -sh "$DIRTOSCAN" 2>/dev/null | cut -f1);
 echo "Starting a daily scan of "$DIRTOSCAN" directory.
 Amount of data to be scanned is "$DIRSIZE".";
sudo clamscan -ri "$DIRTOSCAN" &>"$LOGFILE"

# get the value of "Infected lines"
MALWARE=$(tail "$LOGFILE"|grep Infected|cut -d" " -f3);

# if the value is not equal to zero, send an email with the log file attached
if [ "$MALWARE" -ne "0" ];then
  #using heirloom-mailx below
  echo "$EMAIL_MSG" | sudo mutt -s "Malware Found" "$EMAIL_TO" -a "$LOGFILE" #-s "Malware Found" -r "$EMAIL_FROM" "$EMAIL_TO";
fi

echo "$EMAIL_MSG" | sudo mutt -s "Malware Found" "$EMAIL_TO" -a "$LOGFILE" #

exit 0
#
# # echo "_test attach" | mutt -s "_subject" foteinosmerg@protonmail.com -a .muttrc
