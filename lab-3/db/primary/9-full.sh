#!/bin/sh

echo "[primary] Setting up environment variables..."
source primary/0-env.sh

echo "[primary] Creating '.pgpass' file..."
sh primary/0-pgpass.sh

echo "[primary] Initializing the database..."
sh primary/1-init.sh

echo "[primary] Starting the database..."
sh primary/2-start.sh & 

echo "[primary] Waiting the database startup..."
sleep 2

echo "[primary] Settings up the database..."
sh primary/3-setup.sh

echo "[primary] All right!"
