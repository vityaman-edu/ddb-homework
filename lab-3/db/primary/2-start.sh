#!/bin/sh

set -e

cd "$(dirname "$0")"

"$DDB_PGBIN" -D "$PGDATA"
