#!/bin/sh

set -e

echo "[sql-restore] Restoring the database from an SQL dump..."

restore() {
    echo "[sql-restore] Restoring '$1'..."
    "$DDB_PGRESTORE" \
        --dbname=$1 \
        --host=localhost \
        --port=$DDB_PG_PORT \
        --clean \
        --if-exists \
        $DDB_BACKUP_DUMP_DIR/$1.tar
}

restore $DDB_PG_DATABASE
restore $DDB_NEW_DATABASE_NAME

echo "[sql-restore] Done!"
