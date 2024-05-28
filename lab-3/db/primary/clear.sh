#!/bin/sh

set -e

echo "[standby] Clear backups..."

rm -r $HOME/$DDB_BACKUP_WAL_DIR 2>/dev/null
rm -r $HOME/$DDB_BACKUP_BASE_DIR 2>/dev/null
