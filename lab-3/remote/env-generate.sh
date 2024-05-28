#!/bin/sh

set -e

FILE=./remote/env-remote.sh
echo "export DDB_INITDB=initdb"                     >> $FILE
echo "export DDB_PGBIN=postgres"                    >> $FILE
echo "export DDB_PGBASEBACKUP=pg_basebackup"        >> $FILE
echo "export DDB_PGCTL=pg_ctl"                      >> $FILE
echo "export DDB_PGVERIFYBACKUP=pg_verifybackup"    >> $FILE
echo "export DDB_PGDUMP=pg_dump"                    >> $FILE
echo "export DDB_PGRESTORE=pg_restore"              >> $FILE
echo "export DDB_STANDBY_HOST=$DDB_STANDBY_HOST"    >> $FILE
echo "export DDB_STANDBY_USER=$DDB_STANDBY_USER"    >> $FILE
