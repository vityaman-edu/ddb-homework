#!/bin/sh

set -e

"$DDB_PGBASEBACKUP" \
    --host="localhost" \
    --port="$DDB_PG_PORT" \
    --pgdata="$DDB_PRIMARY_BACKUP_BASE_DIR" \
    --format="tar" \
    --wal-method="fetch" \
    --no-password
