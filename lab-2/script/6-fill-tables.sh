export PRV=postgres
export NEW=lazyorangehair
export TABLESPACE_NAME=yqy90

sql() {
  psql -h localhost -p $POSTGRES_PORT -c "$2" "$1"
}

sql $PRV "CREATE TABLE note_prv (id serial PRIMARY KEY, content text NOT NULL);"
sql $NEW "CREATE TABLE note_new (id serial PRIMARY KEY, content text NOT NULL);"

sql $PRV "INSERT INTO note_prv (content) VALUES ('Note at postgres');"
sql $NEW "INSERT INTO note_new (content) VALUES ('Note at lazyorangehair');"

sql $PRV "SELECT * FROM note_prv;"
sql $NEW "SELECT * FROM note_new;"
