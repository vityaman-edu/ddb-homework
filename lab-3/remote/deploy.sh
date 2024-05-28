#!/bin/sh

set -e

cd "$(dirname "$0")" && cd ..
echo "PWD: $(pwd)"

KIND=$1

echo "[remote] Deploying '$KIND'..."

echo "[remote] Sending directory '$KIND'..."
scp -r -o ProxyJump=$DDB_PROXY_ALIAS ./db/$KIND  $DDB_PROXY_ALIAS-$KIND:~/$KIND

echo "[remote] Sending directory 'common'..."
scp -r -o ProxyJump=$DDB_PROXY_ALIAS ./db/common $DDB_PROXY_ALIAS-$KIND:~/common

echo "[remote] Sending directory 'remote'..."
scp -r -o ProxyJump=$DDB_PROXY_ALIAS ./remote    $DDB_PROXY_ALIAS-$KIND:~/remote
