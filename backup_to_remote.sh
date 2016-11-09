#!/bin/bash
DATE=`date +%F`;
SRCHOST=`hostname`;
SRCPATH=/backup
DESTHOST=backup.remotehost.com
DESTUSER=remoteuser
DESTPATH=/backup
scp $SRCPATH/$DATE-$SRCHOST-* $DESTUSER@$DESTHOST:$DESTPATH
