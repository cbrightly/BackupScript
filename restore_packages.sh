#!/bin/bash
echo "Restoring up apt status / package list";
echo "";
# Backup
#sudo apt-clone --get-selections > dpkglist.txt;
# Restore
   sudo apt-clone restore dpkglist*;
echo "Done!"
echo "";
