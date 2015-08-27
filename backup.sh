#!/bin/bash
DATE=`date +%F` # Grab the date
HOST=`hostname` # Grab the hostname
NAME=`whoami` # Grab username
BACKUPDIR=/backup # Set default destination in root dir
if [[ $EUID -ne 0 ]]; then
  echo "Not root. Backing up home directory only..."
  DATA=$HOME
 else
  echo "root user! Backing up system..."
  DATA=/
 fi
# If destination isn't writable...
  if [ ! -w $BACKUPDIR ] ; then
    echo "Cannot write to /backup; using ~/backup instead!"
    BACKUPDIR=$HOME/backup
  fi
# Does /backup exist?
  if [ ! -d "$BACKUPDIR" ]; then
    mkdir $BACKUPDIR # Try to create destination if not existant
  fi
cd $BACKUPDIR
TARFILE=$NAME-$DATE-$HOST.tgz # Use it to create a filename
tar -czf $TARFILE $DATA --exclude $BACKUPDIR
find $BACKUPDIR -name "*.tgz" -type f -mtime +3 -delete # Delete backups more than 3 days old
