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
DIR=`pwd`;
echo "+==============================================+";
echo "|%%%%    backup.sh: execution begining     %%%%|";
sudo mkdir -p /backup;
sudo tar -czf /backup/$DATE-$HOST-homes_backup.tar.gz /home --exclude=/home/$USER/.bitcoin --exclude=/home/$USER/.litecoin --exclude=/home/$USER/backup;
echo "| + /home made into a tarball in /backup       |";
sudo tar -czf /backup/$DATE-$HOST-www_backup.tar.gz /var/www/;
echo "| + /var/www made into a tarball in /backup    |";
sudo tar -czf /backup/$DATE-$HOST-etc_backup.tar.gz /etc;
echo "| + /etc made into a tarball in /backup        |";
sudo chown $USER /backup -R;
echo "| + Changed ownership of /backup recursively   |";
sudo bash $DIR/clone_packages.sh;
echo "| + Backed up apt state/packages (apt-clone)   |";
echo "|%%%%                                      %%%%|";
echo "|%%%%     backup.sh execution complete     %%%%|";
echo "|%%%%                                      %%%%|";
echo "+==============================================+";
echo "";
