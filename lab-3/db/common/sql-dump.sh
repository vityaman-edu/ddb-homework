#!/bin/sh

set -e

dump() {
    echo "[dump] Dumping '$1'..."
    pg_dump \
        --host=localhost \
        --port=$DDB_PG_PORT \
        --format=tar \
        --clean \
        --if-exists \
        --blobs \
        --file=$DDB_BACKUP_DUMP_DIR/$1.tar \
        $1
}

dump $DDB_PG_DATABASE
dump $DDB_NEW_DATABASE_NAME
