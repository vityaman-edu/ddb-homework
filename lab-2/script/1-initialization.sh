export POSTGRES_USER=postgres0
export POSTGRES_CONFIG_DIRECTORY="./config"
export POSTGRES_SUPER_USER_PASSWORD_FILE="$POSTGRES_CONFIG_DIRECTORY/postgres_su_password.txt"
export POSTGRES_PORT=9666
export PGDATA="$HOME/kop67"

mkdir   $PGDATA                     2> /dev/null

adduser $POSTGRES_USER              2>/dev/null
chown   $POSTGRES_USER $PGDATA

su      $POSTGRES_USER
