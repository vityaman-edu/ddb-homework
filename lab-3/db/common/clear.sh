#!/bin/sh

set -e

echo "Removing the database..."

rm -r $PGDATA 2>/dev/null
rm -r $DDB_TABLESPACE_LOCATION 2>/dev/null
rm -r tablespace 2>/dev/null
