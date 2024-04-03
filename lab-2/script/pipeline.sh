exit 0

# login 1: postgres

cd psql
source script/1-initialization.sh  
source script/2-create.sh  
source script/3-configuration.sh  
source script/4-start.sh

# login 2: root

cd psql
source script/1-initialization.sh
# ctrl+d
source script/5-recreate-template.sh
source script/6-fill-tables.sh

# login 3: postgres
cd psql
source script/1-initialization.sh
source script/7-print.sh
