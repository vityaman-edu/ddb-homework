#!/bin/sh

cd "$(dirname "$0")"

echo "" > ~/.pgpass
echo "localhost:$DDB_PG_PORT:$DDB_PG_DATABASE:$DDB_PG_USER:$DDB_PG_PASS" >> ~/.pgpass
echo "localhost:$DDB_PG_PORT:$DDB_PG_DATABASE:$DDB_NEW_USER:$DDB_NEW_USER_PASSWORD" >> ~/.pgpass
chmod 0600 ~/.pgpass

echo "$DDB_PG_PASS" > "$DDB_PG_PASS_FILE"
