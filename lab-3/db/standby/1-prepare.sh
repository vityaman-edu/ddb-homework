#!/bin/sh

set -e

echo "[standby] Prepairing..."

mkdir -p "$HOME/$DDB_BACKUP_WAL_DIR"
mkdir -p "$HOME/$DDB_BACKUP_BASE_DIR"
