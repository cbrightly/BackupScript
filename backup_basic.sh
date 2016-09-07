#!/bin/bash
########################################################
# >Description:
#    Extremely Rudimentary Backup Shell Script
# >Usage:
#    backup_basic.sh
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
SRC=/;				# Set SCP src
DEST=/backup;			# Set SCP dest
# Where is script running from?
DIR=$( cd $(dirname $0) ; pwd -P );
EXCLUDES="--exclude=/home/$USER/.bitcoin --exclude=/home/$USER/.litecoin --exclude=/home/$USER$DEST";

echo "+==============================================+";
echo "!!!  Working in ""$DIR"" !!!";
echo "|%%%%    backup.sh: execution begining     %%%%|";
sudo mkdir -p $DEST;
sudo tar -czf $DEST/$DATE-$HOST-homes_backup.tar.gz /home $EXCLUDES
echo "| + /home made into a tarball in $DEST       |";
sudo tar -czf $DEST/$DATE-$HOST-www_backup.tar.gz /var/www/;
echo "| + /var/www made into a tarball in $DEST    |";
sudo tar -czf $DEST/$DATE-$HOST-etc_backup.tar.gz /etc;
echo "| + /etc made into a tarball in $DEST        |";
sudo chown $USER $DEST -R;
echo "| + Changed ownership of $DEST recursively   |";
# Backup state of apt packages / settings / etc
sudo bash $DIR/clone_packages.sh
# Move apt-clone backup to backup destination
mv $DIR/*apt*clone* $DEST/$DATE-$HOST-dpkglist.apt-clone.tar.gz
echo "| + Backed up apt state/packages (apt-clone)   |";
echo "|%%%%                                      %%%%|";
echo "|%%%%     backup.sh execution complete     %%%%|";
echo "|%%%%                                      %%%%|";
echo "+==============================================+";
echo "";
