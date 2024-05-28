#!/bin/sh

set -e

cd "$(dirname "$0")"

sql() {
    psql -U "$DDB_PG_USER" -h localhost -p $DDB_PG_PORT -c "$1" $DDB_PG_DATABASE
}

sql "INSERT INTO note_prv (content) VALUES ('The first testing note');"
sql "INSERT INTO note_prv (content) VALUES ('The second testing note');"
sql "INSERT INTO note_prv (content) VALUES ('The third testing note');"
