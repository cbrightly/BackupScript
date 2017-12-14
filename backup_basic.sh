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

DATE=`date +%F`;			# Grab the current date
HOST=`hostname`;			# Grab the hostname
USER=`whoami`;				# Get current username
SRC=/;					# Set default BACKUP src
DEST=/backup;				# Set default BACKUP dest
CHOWNER=$USER:nogroup;			# Set default final owner+group
DIR=$( cd $(dirname $0) ; pwd -P )	# Where is script running from?

EXCLUDES="--exclude=/home/$USER/.bitcoin/* --exclude=/home/$USER/.litecoin/* --exclude=/home/$USER/backup/* --exclude=/home/$USER/.zcash/* --exclude=/home/$USER/.zcash-params/* --exclude=/home/$USER/archives/* --exclude=/home/$USER/*.com/* --exclude=/home/$USER/*.in/* --exclude=/home/$USER/*.tk/* --exclude=/home/$USER/.bitmonero/* --exclude=/home/$USER/www*";
echo " ";
echo "+==============================================+";
echo "|  !! Backup Execution Begining...";
# Create destination directory if not already existant
  sudo if ![ -d $DEST ]; mkdir -p $DEST;
# Move to destination directory
  cd $DEST;
echo "|	 II  Changed current directory to $DEST";
# Backup home folders
  tar -czf $DATE-$HOST-homes_backup.tar.gz /home/$USER $EXCLUDES
  echo "|	 II  /home made into a tarball in $DEST";
# Backup www root
  sudo tar -czf $DATE-$HOST-www_backup.tar.gz /var/www;
  echo "|	 II  /var/www made into a tarball in $DEST";
# Backup /etc
  sudo tar -czf $DATE-$HOST-etc_backup.tar.gz /etc;
  echo "|	 II  /etc made into a tarball in $DEST";
# Backup apt files eight different ways
  sudo tar -czf $DATE-$HOST-var_lib_dpkg.tar.gz /var/lib/dpkg;
  echo "|	 II  /var/lib/dpkg tarballed in $DEST";
  sudo tar -czf $DATE-$HOST-apt_extended_states.tar.gz /var/lib/apt/extended_states;
  echo "|	 II  /var/lib/apt/extended_states backed up";
  sudo dpkg --get-selections "*" > $DEST/$DATE-$HOST-dpkg_get-selections.txt;
  sudo chown $USER $DEST/$DATE-$HOST-dpkg_get-selections.txt;
  sudo tar -czf $DATE-$HOST-dpkg_get-selections.tar.gz $DATE-$HOST-dpkg_get-selections.txt --remove-files
  echo "|	 II  dpkg --get-selections \"*\" backed up";
  sudo tar -czf $DATE-$HOST-pkgstates.tar.gz /var/lib/aptitude/pkgstates;
  echo "|  II  aptitude package states backed up";
  sudo tar -czf $DATE-$HOST-backups.tgz $DATE-$HOST*.tar.gz;
  echo "|	 II  gzip'd tarball made of individual files";
# Remove temporary tar.gz files
  echo "|  II  Removing temporary .tar.gz files";
  sudo rm -f $DATE-$HOST-*.tar.gz;
# Set permissions to user:group as defined near top of file
  sudo chown $CHOWNER $DEST -R;
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
  cd $DIR;
  echo "";
