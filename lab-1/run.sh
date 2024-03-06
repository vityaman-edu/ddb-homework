set -o errexit
cd $(dirname -- $0)

print() {
  YC="\033[1;34m" # Yes Color
  NC="\033[0m"    # No Color
  printf "$YC[test] $1$NC\n"
}

run() {
  print "Running SQL script: $1..."
  psql \
    -h localhost \
    -p 5432 \
    -d $POSTGRES_DB \
    -U $POSTGRES_USER \
    -a -f $1
}

run initialize.sql
run meta.sql
run meta_display.sql
run main.sql

# run table_column.sql
# run table_column_pretty.sql
# run print_table_info.sql
# run get_table_info.sql

print "Done."
