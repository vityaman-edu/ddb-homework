export POSTGRES_USER=postgres
export POSTGRES_CONFIG_DIRECTORY="./config"
export POSTGRES_SUPER_USER_PASSWORD_FILE="$POSTGRES_CONFIG_DIRECTORY/postgres_su_password.txt"
export PGDATA="./kop67"

mkdir   $PGDATA                     2> /dev/null

adduser $POSTGRES_USER              2>/dev/null
chown   $POSTGRES_USER $PGDATA
chmod   og+r $POSTGRES_CONFIG_DIRECTORY

su      $POSTGRES_USER
