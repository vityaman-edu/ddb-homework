#!/bin/sh

set -e

mkdir -p $PGDATA
chmod 0700 $PGDATA

echo "[standby] Extracting base backup..."
tar \
    --extract \
    -f "$HOME/$DDB_BACKUP_BASE_DIR/base.tar" \
    --directory=$PGDATA

echo "[standby] Restoring tablespaces..."
while read -r line; do
    TABLESPACE_OID=$(echo $line | awk '{print $1}')
    TABLESPACE_DIR=$(echo $line | awk '{print $2}')
    echo "[standby][$TABLESPACE_OID] Restoring tablespace..."

    echo "[standby][$TABLESPACE_OID] Directory: $TABLESPACE_DIR"
    mkdir -p $TABLESPACE_DIR

    echo "[standby][$TABLESPACE_OID] Extracting..."
    tar --extract \
        -f $HOME/$DDB_BACKUP_BASE_DIR/$TABLESPACE_OID.tar \
        --directory=$TABLESPACE_DIR

    echo "[standby][$TABLESPACE_OID] Creating symbolic link..."
    ln -s $TABLESPACE_DIR $PGDATA/pg_tblspc/$TABLESPACE_OID
done < $PGDATA/tablespace_map

echo "[standby] Removing 'tablespace_map'..."
rm $PGDATA/tablespace_map

# Patching is used as we need to change values depending on env variables
echo "[standby] Patching postgresql.conf: add 'restore_command'..."
RESTORE_CMD="restore_command = 'cp $HOME/$DDB_BACKUP_WAL_DIR/%f %p'"
echo "\n$RESTORE_CMD\n" >> $PGDATA/postgresql.conf

echo "[standby] Patching postgresql.conf: disable archive..."
sed -i -e "s+archive_mode+#archive_mode+g" $PGDATA/postgresql.conf

echo "[standby] Signalling of recovery..."
touch $PGDATA/recovery.signal

echo "[standby] Is ready for startup!"
