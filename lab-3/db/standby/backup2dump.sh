#!/bin/sh

set -e

TARGET_TIME=$1
if [ "$TARGET_TIME" = "" ]; then
    echo "[backup2dump] Expected TARGET_TIME parameter!"
    exit 1
fi

echo "[backup2dump] Starting converting backup to sql dump..."

echo "[backup2dump] Starting restoration..."
sh common/restore.sh standby "$TARGET_TIME"

echo "[backup2dump] Starting the database..."
sh common/start.sh &

echo "[backup2dump] Waiting the database..."
sleep 2

echo "[backup2dump] Starting dumping..."
sh common/sql-dump.sh

echo "[backup2dump] Shutting down the database..."
sh common/stop.sh

echo "[backup2dump] Done!"
