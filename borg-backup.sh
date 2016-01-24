#!/bin/bash

# borg init --encryption=keyfile $user@$host:borg/

BORG="/usr/local/bin/borg-linux64"

REPOSITORY="$USER"@"$HOST":borg/
export BORG_PASSPHRASE="Your phrase here."

if [ ! -x $BORG ]; then
        echo "I can't execute borg."
        exit 1
fi


$BORG create --stats --compression zlib,8       \
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
