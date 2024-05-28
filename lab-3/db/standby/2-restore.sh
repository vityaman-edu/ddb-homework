#!/bin/sh

set -e

mkdir -p $PGDATA
chmod 0700 $PGDATA

echo "[standby] Extracting base backup..."
tar \
    --extract \
    -f "$HOME/$DDB_PRIMARY_BACKUP_BASE_DIR/base.tar" \
    --directory=$PGDATA

echo "[standby] Restoring tablespaces..."
while read -r line; do
    tablespace_oid=$(echo $line | awk '{print $1}')
    echo "[standby][$tablespace_oid] Restoring tablespace..."

    TABLESPACE_DIR=$HOME/tablespace/$tablespace_oid
    echo "[standby][$tablespace_oid] Directory: $TABLESPACE_DIR"
    mkdir -p $TABLESPACE_DIR

    echo "[standby][$tablespace_oid] Extracting..."
    tar --extract \
        -f $HOME/$DDB_PRIMARY_BACKUP_BASE_DIR/$tablespace_oid.tar \
        --directory=$TABLESPACE_DIR

    echo "[standby][$tablespace_oid] Creating symbolic link..."
    ln -s $TABLESPACE_DIR $PGDATA/pg_tblspc/$tablespace_oid
done < $PGDATA/tablespace_map

echo "[standby] Removing 'tablespace_map'..."
rm $PGDATA/tablespace_map

echo "[standby] Patching postgresql.conf: add 'restore_command'..."
RESTORE_CMD="restore_command = 'cp $HOME/$DDB_STANDBY_BACKUP_WAL_DIR/%f %p'"
echo "\n$RESTORE_CMD\n" >> $PGDATA/postgresql.conf

echo "[standby] Patching postgresql.conf: disable archive..."
sed -i -e "s+archive_mode+#archive_mode+g" $PGDATA/postgresql.conf

echo "[standby] Signalling of recovery..."
touch $PGDATA/recovery.signal

echo "[standby] Is ready for startup!"
