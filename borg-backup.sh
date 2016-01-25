#!/bin/bash

# borg init --encryption=keyfile $user@$host:borg/

BORG="/usr/local/bin/borg-linux64"
COMPRESSION_LEVEL="8" # 6 is default. 0-9.

REPOSITORY="$USER"@"$HOST":borg/
export BORG_PASSPHRASE="Your key's passphrase here."

if [ ! -x $BORG ]; then
        echo "I can't execute borg."
        exit 1
fi


$BORG create -v --stats --compression zlib,"$COMPRESSION_LEVEL"       \
    "$REPOSITORY"::$(hostname)-$(date +%Y-%m-%d)    \
    /home                                       \
    /var/www                                    \
    --exclude /home/kirrus/archive              \
    --exclude '/home/*/logs'                    \
    --exclude '*.pyc'                           \
    --exclude '/var/www/owncloud/data/*/thumbnails/'

sleep 1

$BORG prune -v "$REPOSITORY" --prefix $(hostname)- \
    --keep-daily=7 --keep-weekly=4 --keep-monthly=6
