export TABLESPACE_NAME=yqy90
export TABLESPACE_LOCATION=$HOME/$TABLESPACE_NAME
export NEW_DATABASE_NAME=lazyorangehair
export POSTGRES_PORT=9666
export NEW_USER=root

mkdir $TABLESPACE_LOCATION 2>/dev/null

sql() {
  psql -h localhost -p $POSTGRES_PORT -c "$1" postgres
}

sql "CREATE TABLESPACE $TABLESPACE_NAME LOCATION '$TABLESPACE_LOCATION';"
sql "ALTER DATABASE template1 SET TABLESPACE $TABLESPACE_NAME;"
sql "CREATE DATABASE $NEW_DATABASE_NAME TEMPLATE template1;"
sql "CREATE ROLE tester;"
sql "CREATE USER $NEW_USER WITH LOGIN PASSWORD 'rootik'; GRANT tester TO $NEW_USER;"
