#!/bin/bash
########################################################
# >Description:
#    Extremely Rudimentary Backup Shell Script
# >Usage:
#    bash backup_basic.sh
#         OR
#    ./backup_basic.sh
# >Information:
#    Creates copies of all home directories plus
#    everything in and underneath /var/www/ with
#    the exception of $HOME/.bitcoin and $HOME/.litecoin
#    which hold each blockchain, respectively.
########################################################

DATE=`date +%F`;		# Grab the date
HOST=`hostname`;		# Grab the hostname
USER=`whoami`;			# Get username
SRC=/;				# Set BACKUP  src
DEST=/backup;			# Set BACKUP dest
CHOWNER=$USER:nogroup;
# Where is script running from?
DIR=$( cd $(dirname $0) ; pwd -P );
EXCLUDES="--exclude=/home/$USER/.bitcoin/* --exclude=/home/$USER/.litecoin/* --exclude=/home/$USER/backup/* --exclude=/home/$USER/.zcash/* --exclude=/home/$USER/.zcash-params/*";
echo " ";
echo "+==============================================+";
echo "| 	!!! backup execution begining";
sudo mkdir -p $DEST;
cd $DEST;
echo "|		! Changed current directory to $DEST";
tar -czf $DATE-$HOST-homes_backup.tar.gz /home $EXCLUDES
echo "|		! /home made into a tarball in $DEST";
sudo tar -czf $DATE-$HOST-www_backup.tar.gz /var/www;
echo "|		! /var/www made into a tarball in $DEST";
sudo tar -czf $DATE-$HOST-etc_backup.tar.gz /etc;
echo "|		! /etc made into a tarball in $DEST";
sudo tar -czf $DATE-$HOST-var_lib_dpkg.tar.gz /var/lib/dpkg;
echo "|		! /var/lib/dpkg tarballed in $DEST";
sudo tar -czf $DATE-$HOST-apt_extended_states.tar.gz /var/lib/apt/extended_states;
echo "|		! /var/lib/apt/extended_states backed up";
sudo dpkg --get-selections "*" > $DEST/$DATE-$HOST-dpkg_get-selections.txt;
sudo chown $USER $DEST/$DATE-$HOST-dpkg_get-selections.txt;
tar -czf $DATE-$HOST-dpkg_get-selections.tar.gz $DATE-$HOST-dpkg_get-selections.txt --remove-files
echo "|		! dpkg --get-selections \"*\" backed up";
sudo tar -czf $DATE-$HOST-pkgstates.tar.gz /var/lib/aptitude/pkgstates;
echo "|		! aptitude package states backed up";
sudo tar -czf $DATE-$HOST-backup.tar.gz tar -czf $DATE-$HOST-*.tar.gz --exclude=$DATE-$HOST-backup.*;
echo "|		! gzip'd tarball made of individual files";
sudo chown $CHOWNER $DEST -R;
echo "| ";
echo "| ! Ownership of:";
echo "| $DEST:";
echo "|		set recursively to:";
echo "|	$USER";
echo "| ";
echo "| * Files are inside $DEST";
echo "| * ... and are prefixed by $DATE-$HOST-";
echo "| 	!!! backup execution  complete";
echo "+===============================================+";
cd $DIR;	# Return from whence we came
echo "";
