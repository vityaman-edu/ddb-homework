#!/bin/sh

set -e

echo "Removing the database..."

rm -r $PGDATA
rm -r $DDB_TABLESPACE_LOCATION
