export PRV=postgres
export NEW=lazyorangehair

sql() {
  psql -h localhost -p $POSTGRES_PORT -d $PRV -f $1
}

sql "script/tablespace.sql"
