#!/bin/bash
####################
#
#  Written by:
#     Chris Brightly <chris.brightly@gmail.com>
#  Description:
#     Simple BASH script for backup which takes no
#     arguments.
#  Usage:
#     sh backup.sh
#         OR
#     ./backup.sh
#
########################################################
#
# If run as root then / is backed up to a tgz file. If
# user is NOT root, then it creates a tgz of $HOME.
# Regardless of username, the script attempts to backup
# /var/www to a seperate tgz file.
#
########################################################
##
# Changing these allows for finer control over script
# paramaters, however setting these incorrectly can
# stop the script from executing properly...
# You should only change these if you are SURE you know
# what you're doing!
#
########################################################
#
# <----- SCRIPT SETTINGS VARIABLES ----->
#
DATE=`date +%F`		# Grab the date
HOST=`hostname`		# Grab the hostname
NAME=`whoami`		# Grab username
DESTINATION=/backup	# Set default destination
SOURCE=/		# Default dir to backup
BACKUP_WWW=TRUE		# Backup $WEB + default data?
WEB=/var/www		# web home
RETAIN=3		# Days to keep existing backups
TEMP=/tmp
#
# !! You shouldn't need to change anything below here !!

# Check user & permissions, set src and dest accordingly
if [ ! $(id -u) = 0 ]; then
  echo -e "!!! NOT !!! running as root.\nAttempting backup of home directory only...\n"
  SOURCE=$HOME
  DESTINATION=$SOURCE/backup
 else
  echo -e "!!! Running as root!!!\nBacking up $SOURCE to $DESTINATION!\n"
  SOURCE=/
  DESTINATION=$SOURCE/backup
fi

# Does backup destination exist?
if [ ! -d $DESTINATION ]; then
  # Non-existant backup destination!
  echo -e "Backup destination doesn't exist!\n"
  if [ $(mkdir $DESTINATION) ]; then # Try to create destination if not existant
    echo -e "$DESTINATION created..."
  else
  # Can't create default backup dir
    echo -e "Can't create $DESTINATION..."
    if [ $(ls -d -- "$HOME/backup" > /dev/null 2>&1) ]; then
    # if [ -d $HOME/backup ]; then
      if [ -w $HOME/backup ]; then
	DESTINATION=$HOME/backup
	echo -e "Backup of data being created in $DESTINATION.\n"
	mkdir $DESTINATION
      else
	echo -e "Cannot write to $HOME/backup, aborting!\n"
	exit
      fi
    else
      echo -e "No suitable backup destinations. Aborting!\n"
      exit
    fi
  fi
fi

# If $DESTINATION isn't writable...
if [ ! -w $DESTINATION ]; then
  DESTINATION=$HOME/backup
  if [ ! -w $DESTINATION ]; then
    echo -e "Can't write to $DESTINATION! Aborting!"
    exit
  else
    # If we CAN write to $DESTINATION
    echo -e "$DESTINATION verified as writable\n"
    echo -e "Writing backup to $DESTINATION...\n"
  fi
fi

cd $TEMP
# Use variables to create a filename
FILEMAIN=$TEMP/$NAME-$DATE-$HOST.tar.gz
FILEWWW=$TEMP/$NAME-$DATE-$HOST-www.tar.gz

echo -e "Creating main backup in file $FILEMAIN."
tar -czf $FILEMAIN $SOURCE --exclude $DESTINATION --exclude $DESTINATION/.bitcoin > /dev/null 2>&1
# Create backup of $WWW
echo -e "Creating web backup in file $FILEWWW."
tar -czf $FILEWWW $WEB --exclude $DESTINATION --exclude $DESTINATION/.bitcoin > /dev/null 2>&1
# Move files from temp directory to final dir
mv $FILEMAIN $FILEWWW $DESTINATION

cd $DESTINATION

# Delete backups more than # days old
# echo -e "Finding and deleting backup files older than $RETAIN days.."
# find $DESTINATION -name "*.tgz" -type f -mtime +$RETAIN -delete
# All done!
echo -e "Success! Backup sources:  $WWW_ROOT and $SOURCE\nBackup(s) destination: $DESTINATION!\n"
# echo -e "Successfully purged pre-existing backup files older than $RETAIN days!\n"
echo -e "*** Backup Script Completed! ***\n"
