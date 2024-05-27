#!/bin/sh

set -e

sed -i -e "s+<STANDBY_HOST>+$DDB_STANDBY_HOST+g" primary/postgresql.conf
sed -i -e "s+<STANDBY_WAL_DIR>+$DDB_STANDBY_BACKUP_WAL_DIR+g" primary/postgresql.conf
