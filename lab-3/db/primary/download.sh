#!/bin/sh

set -e

rsync -ave ssh \
    $DDB_STANDBY_USER@$DDB_STANDBY_HOST:~/$DDB_BACKUP_DIR \
    "$HOME/primary"
