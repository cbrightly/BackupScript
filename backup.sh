#!/bin/bash

# Written by:
#  Chris Brightly <chris.brightly@gmail.com>
#
# Simple BASH script for backup which takes no arguments.
#
# If root user then backs up entire system to a tgz. If the
# user is NOT root, then it creates a tgz of $HOME.
# Regardless of username, the script attempts to backup
# /var/www to a seperate tgz file.
# If /backup exists and is writable 

# Usage: sh backup.sh

# Define variables here
DATE=`date +%F`   # Grab the date
HOST=`hostname`	  # Grab the hostname
NAME=`whoami`	  # Grab username
DESTINATION=$HOME/backup # Set default destination
SOURCE=$HOME	  # Default source for direcrory to backup
WEB=/var/www	  # web home

# Check user & permissions, set src and dest accordingly
if ! [ $(id -u) = 0 ]; then
  echo "NOT running using root permissions. Backing up home directory only..."
  SOURCE=$HOME
  DESTINATION=$HOME/backup
 else
  echo "Running as root user / with root  permissions! Backing up system..."
  SOURCE=/
  DESTINATION=/backup
fi

# Does backup destination exist?
if [ ! -d $DESTINATION ]; then
	echo "Backup destination doesn't exist!"
	if [ mkdir $DESTINATION ]; then # Try to create destination if not existant
		echo $DESTINATION " created..."
	else
		echo "Can't create " $DESTINATION ", aborting!"
		exit 2
	fi
else
	echo "Backing up to " $DESTINATION "..."
fi

# If destination isn't writable...
if [ ! -w /backup ]; then
    echo "Cannot write to /backup; using ~/backup instead!"
    DESTINATION=$HOME/backup
else
    echo "Writing backup to " $DESTINATION "..."
fi

cd $DESTINATION
TARFILE=$NAME-$DATE-$HOST.tgz # Use it to create a filename
tar -czf $TARFILE $SOURCE --exclude $DESTINATION
TARFILE=$NAME-$DATE-$HOST-www.tgz # Create backup of www
tar -czf $TARFILE $WEB --exclude $DESTINATION
# find $DESTINATION -name "*.tgz" -type f -mtime +3 -delete # Delete backups more than 3 days old
