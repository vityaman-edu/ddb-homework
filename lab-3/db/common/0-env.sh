#!/bin/sh

export DDB_PG_CONF="."
export DDB_PG_USER="postgres0"
export DDB_PG_PASS="pleasehelp"
export DDB_PG_PASS_FILE="$DDB_PG_CONF/pgpass.txt"
export DDB_PG_PORT=9666
export DDB_PG_DATABASE=postgres

export DDB_TABLESPACE_NAME=yqy90
export DDB_TABLESPACE_LOCATION="$HOME/$DDB_TABLESPACE_NAME"
export DDB_NEW_DATABASE_NAME=lazyorangehair
export DDB_NEW_USER=root
export DDB_NEW_USER_PASSWORD=rootik

export PGDATA="$HOME/kop67"

export DDB_INITDB=/usr/lib/postgresql/14/bin/initdb
export DDB_PGBIN=/usr/lib/postgresql/14/bin/postgres
export DDB_PGBASEBACKUP=/usr/lib/postgresql/14/bin/pg_basebackup

export DDB_BACKUP_DIR="primary/backup"
export DDB_BACKUP_BASE_DIR="$DDB_BACKUP_DIR/base"
export DDB_BACKUP_WAL_DIR="$DDB_BACKUP_DIR/wal"

export DDB_STANDBY_HOST=ddb-standby
