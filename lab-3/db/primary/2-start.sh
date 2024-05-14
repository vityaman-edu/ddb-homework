#!/bin/sh

cd "$(dirname "$0")"

"$DDB_PGBIN" -D "$PGDATA"
