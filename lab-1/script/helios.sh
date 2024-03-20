set -o errexit
cd $(dirname -- $0)
cd ../sql

print() {
  YC="\033[1;34m" # Yes Color
  NC="\033[0m"    # No Color
  printf "$YC[ddb] $1$NC\n"
}

run() {
  print "Running SQL script: $1..."
  psql -h pg -d studs -f $1
}

print "Starting defending the 1st lab solution..."

run initialize.sql
run meta.sql
run meta_display.sql
run main.sql

print "Done!"
