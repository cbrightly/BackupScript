#!/bin/bash
####################
# Written by:
#   Chris Brightly <chris.brightly@gmail.com>
# Description:
#   Simple BASH script for backup which takes no arguments.
####################
# If root user then backs up entire system to a tgz. If the
# user is NOT root, then it creates a tgz of $HOME.
# Regardless of username, the script attempts to backup
# /var/www to a seperate tgz file.
# Usage: sh backup.sh
####################
# <----- SCRIPT SETTINGS VARIABLES ----->
# Changing these allows for finer control over script paramaters, however
# setting these incorrectly can stop the script from executing properly...
# You should only change these if you are SURE you know what you're doing!
DATE=`date +%F`		# Grab the date
HOST=`hostname`		# Grab the hostname
NAME=`whoami`		# Grab username
DESTINATION=/backup	# Set default destination
SOURCE=/		# Default source for direcrory to backup
WEB=/var/www		# web home
RETAIN=3		# Time in days to keep pre-existing backup files

# Check user & permissions, set src and dest accordingly
if ! [ $(id -u) = 0 ]; then
  echo "NOT running using root permissions. Backing up home directory only..."
  SOURCE=$HOME
 else
  echo "Running as root user / with root  permissions! Backing up " $SOURCE " to " $DESTINATION "!"
  SOURCE=/
fi

# Does backup destination exist?
if [ ! -d $DESTINATION ]; then
	# Non-existant backup destination!
	echo "Backup destination doesn't exist!"
	if [ mkdir $DESTINATION ]; then # Try to create destination if not existant
		echo $DESTINATION " created..."
	else
	        # Can't create the backup destination either
		echo "Can't create " $DESTINATION ", aborting!"
		exit 2
	fi
fi

# If $DESTINATION isn't writable...
if [ ! -w $DESTINATION ]; then
    DESTINATION=$HOME/backup
    if [ ! -w $DESTINATION ]; then
        echo "Can't write to " $DESTINATION "! Aborting!"
        exit 2
    else
        # If we CAN write to $DESTINATION
        echo $DESTINATION " verified as writable;"
        echo "Writing backup to " $DESTINATION "..."
    fi
fi

cd $DESTINATION
TARFILE=$NAME-$DATE-$HOST.tgz		# Use variables to create a filename
echo "Creating main backup in file " $TARFILE "."
tar -czf $TARFILE $SOURCE --exclude $DESTINATION > /dev/null 2>&1
TARFILE=$NAME-$DATE-$HOST-www.tgz	# Create backup of $WWW
echo "Creating web backup in file " $TARFILE "."
tar -czf $TARFILE $WEB --exclude $DESTINATION > /dev/null 2>&1
## Delete backups more than 3 days old
# echo "Finding and deleting backup files older than " $RETAIN " days.."
# find $DESTINATION -name "*.tgz" -type f -mtime +$RETAIN -delete

# All done!
echo "Successfully created backups of WWW_ROOT and " $SOURCE " inside " $DESTINATION "!"
# echo "Successfully purged pre-existing backup files older than " $RETAIN " days!"
echo "Backup Script Completed!"
