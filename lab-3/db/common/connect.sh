#!/bin/sh

set -e

psql -U "$DDB_PG_USER" -h localhost -p $DDB_PG_PORT $1
