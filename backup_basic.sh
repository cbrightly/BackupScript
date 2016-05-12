#!/bin/bash
# Extremely Rudimentary Backup Shell Script
# backup_basic.sh

# Description:
#  Creates copies of all home directories plus
#  everything in and underneath /var/www/ with
#  the exception of ~/.bitcoin and ~/.litecoin
#  which hold each blockchain, respectively.
DATE=`date +%F` # Grab the date
HOST=`hostname` # Grab the hostname


echo "[=============================================]";
echo "%%%%%    backup.sh: execution begining    %%%%%";
sudo mkdir -p /backup;
sudo tar -czf /backup/$DATE-$HOST-homes_backup.tar.gz /home --exclude=~/.bitcoin --exclude=~/.litecoin;
echo " + /home made into a tarball in /backup";
sudo tar -czf /backup/$DATE-$HOST-www_backup.tar.gz /var/www/;
echo " + /var/www made into a tarball in /backup";
sudo chown redukt:redukt /backup -R;
echo " + Changed ownership of /backup recursively";
echo "%%%%%    backup.sh execution complete     %%%%%";
echo "[=============================================]";
echo "";
