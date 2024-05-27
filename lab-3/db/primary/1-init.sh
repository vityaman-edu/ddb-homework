#!/bin/sh

cd "$(dirname "$0")"

mkdir "$PGDATA" 2> /dev/null

"$DDB_INITDB" \
  --pgdata="$PGDATA" \
  --locale="ru_RU.CP1251" \
  --encoding="WIN1251" \
  --pwfile="$DDB_PG_PASS_FILE"

cp "$DDB_PG_CONF/pg_hba.conf" "$PGDATA/pg_hba.conf"
cp "$DDB_PG_CONF/postgresql.conf" "$PGDATA/postgresql.conf"
