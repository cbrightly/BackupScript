#!/bin/bash
########################################################
# > Description:
#    Extremely Rudimentary Backup Shell Script
# > Usage:
#    bash backup_basic.sh
#         OR
#    ./backup_basic.sh
# > Information:
#    Creates copies of all home directories plus
#    everything in and underneath /var/www/ with
#    the exception of $HOME/.bitcoin and $HOME/.litecoin
#    which hold each blockchain, respectively.
########################################################

DATE=$(date +%F);				# Grab the current date
HOST=$(hostname);				# Grab the hostname
USER=$(whoami);					# Get current username
SRC=/;						# Set default BACKUP src
DEST=/backup;					# Set default BACKUP dest
CHOWNER=$USER:nogroup;				# Set default final owner+group
DIR=$( cd "$(dirname "$0")" || echo "Couldn't cd to $(dirname "$0")... quitting!" && exit ; pwd -P )	# Where is script running from?
EXCLUDES="--exclude=$HOME/.bitcoin/* --exclude=$HOME/.litecoin/* --exclude=$HOME/backup/* --exclude=$HOME/.zcash/* --exclude=$HOME/.zcash-params/* --exclude=$HOME/archives/* --exclude=$HOME/*.com/* --exclude=$HOME/*.in/* --exclude=$HOME/*.tk/* --exclude=$HOME/.bitmonero/* --exclude=$HOME/www*";

echo " ";
echo "+==============================================+";
echo "|  !! Backup Execution Begining...";
# Create destination directory if not already existant
# TODO: Need to check for write permission as well
  if ! [ -d "$DEST" ]; then sudo mkdir -p "$DEST" && sudo chown "$CHOWNER" "$DEST"; fi;
# Move to destination directory
  cd "$DEST" || sudo mkdir -p "$DEST" #echo "Couldn't cd to $DEST... quitting!" && exit;
  echo "|	 II  Changed current directory to $DEST";
# Backup home folders
  FILENAME="$DATE"-"$HOST"-home_backup.tar.gz;
  tar -czf "$FILENAME" "$HOME" "$EXCLUDES";
  echo "|	 II  $HOME made into a tarball in $DEST";
# Backup www root
  FILENAME="$DATE"-"$HOST"-www_backup.tar.gz;
  sudo tar -czf "$FILENAME" /var/www;
  echo "|	 II  /var/www made into a tarball in $DEST";
# Backup /etc
  FILENAME="$DATE"-"$HOST"-etc_backup.tar.gz;
  sudo tar -czf "$FILENAME" /etc;
  echo "|	 II  /etc made into a tarball in $DEST";
# Backup apt files eight different ways
  FILENAME="$DATE"-"$HOST"-var_lib_dpkg.tar.gz;
  sudo tar -czf "$FILENAME" /var/lib/dpkg;
  echo "|	 II  /var/lib/dpkg tarballed in $DEST";
  FILENAME="$DATE"-"$HOST"-apt_extended_states.tar.gz;
  sudo tar -czf "$FILENAME" /var/lib/apt/extended_states;
  echo "|	 II  /var/lib/apt/extended_states backed up";
  FILENAME="$DATE"-"$HOST"-dpkg_get-selections.txt;
  sudo dpkg --get-selections "*" | sudo tee "$FILENAME";
  sudo chown "$USER" "$DEST"/"$DATE"-"$HOST"-dpkg_get-selections.txt;
  sudo tar -czf "$FILENAME" "$DATE"-"$HOST"-dpkg_get-selections.txt --remove-files;
  echo "|	 II  dpkg --get-selections \"*\" backed up";
  sudo tar -czf "$DATE"-"$HOST"-pkgstates.tar.gz /var/lib/aptitude/pkgstates;
  echo "|  II  aptitude package states backed up";
  sudo tar -czf "$DATE"-"$HOST"-backups.tgz "$DATE"-"$HOST"*.tar.gz;
  echo "|	 II  gzip'd tarball made of individual files";
# Remove temporary tar.gz files
  echo "|  II  Removing temporary .tar.gz files";
  sudo rm -f "$DATE"-"$HOST"-*.tar.gz;
# Set permissions to user:group as defined near top of file
  sudo chown "$CHOWNER" "$DEST" -R;
  echo "| ";
  echo "|  II  Ownership of:";
  echo "|  II  $DEST:";
  echo "|  II  Set recursively to:";
  echo "|	 II  $USER";
  echo "| ";
# Summarize for user at finish
  echo "|  II  Files are inside $DEST";
  echo "|  II  ... and are prefixed by $DATE-$HOST-";
  echo "|  !!  Execution complete...";
  echo "+===============================================+";
# Return from whence we came
  cd "$DIR" || echo "Couldn't cd to $DIR! Quitting..." && exit;
  echo "";
