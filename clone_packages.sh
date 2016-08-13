#!/bin/bash
echo "Backing up apt status / package list";
echo "";
# Backup
sudo apt-clone clone --with-dpkg-status --with-dpkg-repack dpkglist;
# Restore
#   sudo apt-clone --set-selections < dpkglist.txt;
echo "Done!"
echo "";
