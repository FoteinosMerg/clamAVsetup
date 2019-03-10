#!/bin/bash

# USAGE
#./clam-report.sh <DIR_TO_SCAN> <EMAIL_TO>

DIR_TO_SCAN=$1;
DIR_SIZE=$(sudo du -sh "$DIR_TO_SCAN" 2>/dev/null | cut -f1); # humam readable size
DIR_SIZE_KBYTES=$(sudo du -s "$DIR_TO_SCAN" 2>/dev/null | cut -f1); # size in kilobytes
N=10 # niceness default value
EMAIL_TO=$2
EMAIL_BODY="Please read the .log file attached"
SUBJECT="* MALWARE FOUND *"

echo
echo "Updating database..."
sleep .75
echo
sudo freshclam --verbose
sleep .75
echo
echo "Database updated"
sleep .75

# Resolve niceness according to directory size
if [ "$DIR_SIZE_KBYTES" -ge 500000000 ]; then          # 500 GB <= size
  N=4
elif [ "$DIR_SIZE_KBYTES" -ge 100000000 ]; then        # 100 GB <= size < 500 GB
  N=4
elif [ "$DIR_SIZE_KBYTES" -ge 10000000 ]; then         #  10 GB <= size < 100 GB
  N=4
elif [ "$DIR_SIZE_KBYTES" -ge 1000000 ]; then          #   1 GB <= size < 10 GB
  N=4
elif [ "$DIR_SIZE_KBYTES" -ge 100000 ]; then           # 100 MB <= size < 1 GB
  N=4
fi

echo
echo "Directory to be scanned : "$DIR_TO_SCAN""
sleep .75
echo "Amount of data          : $DIR_SIZE"
sleep .75
echo "Niceness level          : $N"
sleep .75
LOG_FILE="clamav_$(sudo date +"%Y-%m-%d_%H-%M-%S").log" # Identified by date-time
touch "$LOG_FILE"
echo "Started at              : $(sudo date +"%H:%M:%S, %Y-%m-%d")"
echo
echo "Scanning..."
echo

if [ $DIR_SIZE > 0 ]; then
  echo "size $DIR_SIZE_KBYTES kbytes"
  # nice -n"$N" ls -rtlha
else
  echo 'negative'
fi
# -------------------------------------------------

# if [ "$TODAY" == "6" ];then
#  echo "Starting a full weekend scan.";
#
#  # be nice to others while scanning the entire root
#  sudo nice -n5 clamscan -ri / --exclude-dir=/sys/ &>"$LOGFILE";
# else
#
#  echo "Starting a daily scan of "$DIR_TO_SCAN" directory.
#  Amount of data to be scanned is "$DIRSIZE".";
#
#  sudo clamscan -ri "$DIR_TO_SCAN" &>"$LOGFILE";
# fi


#  echo "Starting a daily scan of "$DIR_TO_SCAN" directory.
#  Amount of data to be scanned is "$DIRSIZE".";
# sudo clamscan -ri "$DIR_TO_SCAN" &>"$LOGFILE"
#
# # get the value of "Infected lines"
# MALWARE=$(tail "$LOGFILE"|grep Infected|cut -d" " -f3);
#
# # if the value is not equal to zero, send an email with the log file attached
# if [ "$MALWARE" -ne "0" ];then
#   #using heirloom-mailx below
#   echo "$EMAIL_MSG" | sudo mutt -s "Malware Found" "$EMAIL_TO" -a "$LOGFILE" #-s "Malware Found" -r "$EMAIL_FROM" "$EMAIL_TO";
# fi
#
# echo "$EMAIL_MSG" | sudo mutt -s "Malware Found" "$EMAIL_TO" -a "$LOGFILE" #

# ----------------
# echo "$SUBJECT"
# sudo mv "$LOG_FILE" ~/.clamav-logs/"$LOG_FILE"
# ----------------

exit 0
