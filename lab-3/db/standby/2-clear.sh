#!/bin/sh

set -e

echo "[standby] Clear backups..."

rm -r $HOME/$DDB_BACKUP_WAL_DIR
rm -r $HOME/$DDB_BACKUP_BASE_DIR

sh standby/1-prepare.sh
