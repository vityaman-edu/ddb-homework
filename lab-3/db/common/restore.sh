#!/bin/sh

# set -e

INSTANCE=$1
echo "[restore] INSTANCE: $INSTANCE"

MODE=$2
echo "[restore] MODE: $MODE"

TARGET_TIME=$3
echo "[restore] TARGET_TIME: $TARGET_TIME"

echo "[restore] Removing existing database installation..."
sh common/clear.sh

mkdir -p $PGDATA
chmod 0700 $PGDATA

echo "[restore] Extracting base backup..."
tar \
    --extract \
    -f "$HOME/$DDB_BACKUP_BASE_DIR/base.tar" \
    --directory=$PGDATA

echo "[restore] Restoring tablespaces..."
while read -r line; do
    TABLESPACE_OID=$(echo $line | awk '{print $1}')

    if [ "$MODE" = "anon-tblspc" ]; then
        TABLESPACE_DIR="$HOME/tablespace/$TABLESPACE_OID"
    else
        TABLESPACE_DIR=$(echo $line | awk '{print $2}')
    fi

    echo "[restore][$TABLESPACE_OID] Restoring tablespace..."

    echo "[restore][$TABLESPACE_OID] Directory: $TABLESPACE_DIR"
    mkdir -p $TABLESPACE_DIR

    echo "[restore][$TABLESPACE_OID] Extracting..."
    tar --extract \
        -f "$HOME/$DDB_BACKUP_BASE_DIR/$TABLESPACE_OID.tar" \
        --directory=$TABLESPACE_DIR

    echo "[restore][$TABLESPACE_OID] Creating symbolic link..."
    ln -s $TABLESPACE_DIR $PGDATA/pg_tblspc/$TABLESPACE_OID
done < $PGDATA/tablespace_map

echo "[restore] Checking base backup integrity..."
"$DDB_PGVERIFYBACKUP" \
    --manifest-path="$HOME/$DDB_BACKUP_BASE_DIR/backup_manifest" \
    --wal-directory="$HOME/$DDB_BACKUP_WAL_DIR" \
    $PGDATA

echo "[restore] Removing 'tablespace_map'..."
rm $PGDATA/tablespace_map

# Patching is used as we need to change values depending on env variables
echo "[restore] Patching postgresql.conf: add 'restore_command'..."
RESTORE_CMD="restore_command = 'cp ~/$DDB_BACKUP_WAL_DIR/%f %p'"
echo "$RESTORE_CMD" >> $PGDATA/postgresql.conf

if [ "$INSTANCE" = "standby" ]; then
    echo "[restore] Patching postgresql.conf: disable archive..."
    sed -i -e "s+archive_mode+#archive_mode+g" $PGDATA/postgresql.conf
fi

if [ "$TARGET_TIME" != "" ]; then
    echo "[restore] Patching postgresql.conf: setting target time..."
    echo "recovery_target_time = '$TARGET_TIME'" >> $PGDATA/postgresql.conf
    echo "recovery_target_inclusive = false"     >> $PGDATA/postgresql.conf
fi

echo "[restore] Signalling of recovery..."
touch $PGDATA/recovery.signal

echo "[restore] Is ready for startup!"
