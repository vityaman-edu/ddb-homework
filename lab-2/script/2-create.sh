export PG_BIN=/usr/lib/postgresql/14/bin

"initdb" \
  --pgdata=$PGDATA \
  --locale="ru_RU.CP1251" \
  --encoding=WIN1251 \
  --pwfile=$POSTGRES_SUPER_USER_PASSWORD_FILE
