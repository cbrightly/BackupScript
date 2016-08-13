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
#
# !! You shouldn't need to change anything below here !!

# Check user & permissions, set src and dest accordingly
if ! [ $(id -u) = 0 ]; then
  echo "NOT running as root. Attempting backup of home directory only..."
  SOURCE=$HOME
 else
  echo "Running as root! Backing up " $SOURCE " to " $DESTINATION "!"
  SOURCE=/
fi

# Does backup destination exist?
if [ ! -d $DESTINATION ]; then
  # Non-existant backup destination!
  echo "Backup destination doesn't exist!"
  if [ mkdir $DESTINATION ]; then # Try to create destination if not existant
    echo $DESTINATION " created..."
  else
  # Can't create default backup dir
    echo "Can't create " $DESTINATION "..."
    if [ -d $HOME/backup ]; then
      if [ -w $HOME/backup ]; then
	DESTINATION=$HOME/backup
	echo "Backup of data being created in " $DESTINATION "."
      else
	echo "Cannot write to $HOME/backup, aborting!"
	return 1
      fi
    else
      echo "No suitable backup destinations. Aborting!"
      return 1
    fi
  fi
fi

# If $DESTINATION isn't writable...
if [ ! -w $DESTINATION ]; then
  DESTINATION=$HOME/backup
  if [ ! -w $DESTINATION ]; then
    echo "Can't write to " $DESTINATION "! Aborting!"        return 1
  else
    # If we CAN write to $DESTINATION
    echo $DESTINATION " verified as writable;"
    echo "Writing backup to " $DESTINATION "..."
  fi
fi

cd $DESTINATION
# Use variables to create a filename
TARFILE=$NAME-$DATE-$HOST.tgz
echo "Creating main backup in file " $TARFILE "."
tar -czf $TARFILE $SOURCE --exclude $DESTINATION $DESTINATION/.bitcoin > /dev/null 2>&1
# Create backup of $WWW
TARFILE=$NAME-$DATE-$HOST-www.tgz
echo "Creating web backup in file " $TARFILE "."
tar -czf $TARFILE $WEB --exclude $DESTINATION $DESTINATION/.bitcoin > /dev/null 2>&1
# Delete backups more than # days old
# echo "Finding and deleting backup files older than " $RETAIN " days.."
# find $DESTINATION -name "*.tgz" -type f -mtime +$RETAIN -delete
# All done!
echo "Successfully created backups of WWW_ROOT and " $SOURCE " inside " $DESTINATION "!"
# echo "Successfully purged pre-existing backup files older than " $RETAIN " days!"
echo "Backup Script Completed!"
echo ""
