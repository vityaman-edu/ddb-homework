#!/bin/sh

cd "$(dirname "$0")"

sql() {
    psql -h localhost -p "$DDB_PG_PORT" -c "$1" "$DDB_PG_DATABASE"
}

mkdir "$DDB_TABLESPACE_LOCATION" 2>/dev/null

sql "CREATE TABLESPACE $DDB_TABLESPACE_NAME LOCATION '$DDB_TABLESPACE_LOCATION';"
sql "ALTER DATABASE template1 SET TABLESPACE $DDB_TABLESPACE_NAME;"
sql "CREATE DATABASE $DDB_NEW_DATABASE_NAME TEMPLATE template1;"
sql "CREATE ROLE tester;"
sql "CREATE USER $DDB_NEW_USER WITH LOGIN PASSWORD 'rootik';"
sql "GRANT tester TO $DDB_NEW_USER;"

sql() {
  psql -U "$DDB_NEW_USER" -h localhost -p $DDB_PG_PORT -c "$2" "$1"
}

PRV="$DDB_PG_DATABASE"
NEW="$DDB_NEW_DATABASE_NAME"

sql "$PRV" "CREATE TABLE note_prv (id serial PRIMARY KEY, content text NOT NULL);"
sql "$NEW" "CREATE TABLE note_new (id serial PRIMARY KEY, content text NOT NULL);"

sql "$PRV" "INSERT INTO note_prv (content) VALUES ('Note at postgres');"
sql "$NEW" "INSERT INTO note_new (content) VALUES ('Note at lazyorangehair');"

sql "$PRV" "SELECT * FROM note_prv;"
sql "$NEW" "SELECT * FROM note_new;"
