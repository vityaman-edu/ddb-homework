#!/bin/sh

set -e

echo "[primary] Creating base backup..."
"$DDB_PGBASEBACKUP" \
    --host="localhost" \
    --port="$DDB_PG_PORT" \
    --pgdata="$HOME/$DDB_PRIMARY_BACKUP_BASE_DIR" \
    --format="tar" \
    --wal-method="fetch" \
    --no-password

echo "[primary] Sending to '$DDB_STANDBY_HOST'..."
rsync -ave ssh "$HOME/$DDB_PRIMARY_BACKUP_BASE_DIR" $DDB_STANDBY_HOST:~/$DDB_PRIMARY_BACKUP_DIR
