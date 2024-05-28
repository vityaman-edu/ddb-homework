#!/bin/sh

set -e

cd "$(dirname "$0")"

sql() {
    psql -U "$DDB_PG_USER" -h localhost -p $DDB_PG_PORT -c "$2" "$1"
}

PRV="$DDB_PG_DATABASE"
NEW="$DDB_NEW_DATABASE_NAME"

sql "$PRV" "INSERT INTO note_prv (content) VALUES ('Another note at postgres');"
sql "$NEW" "INSERT INTO note_new (content) VALUES ('Another note at lazyorangehair');"

sql() {
  psql -U "$DDB_PG_USER" -h localhost -p $DDB_PG_PORT -d $PRV -f $1
}

sql sql/01-init-tables.sql 
sql sql/02-init-data.sql
