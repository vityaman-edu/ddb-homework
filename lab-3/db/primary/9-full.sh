#!/bin/sh

set -e

echo "[primary] Creating '.pgpass' file..."
sh common/0-pgpass.sh

echo "[primary] Editing 'postgresql.conf' file..."
sh primary/1-config.sh

echo "[primary] Initializing the database..."
sh primary/1-init.sh

echo "[primary] Starting the database..."
sh common/2-start.sh & 

echo "[primary] Waiting the database startup..."
sleep 2

echo "[primary] Settings up the database..."
sh primary/3-setup.sh

echo "[primary] All right!"
