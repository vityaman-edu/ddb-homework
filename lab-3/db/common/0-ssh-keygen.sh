#!/bin/sh

set -e

echo "[primary] Generating ssh key..."
ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""

echo "[primary] Generated ssh key:"
cat ~/.ssh/id_rsa.pub
