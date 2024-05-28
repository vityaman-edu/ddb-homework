#!/bin/sh

set -e

cd "$(dirname "$0")"

docker compose up --detach --build --force-recreate --remove-orphans

sh deploy.sh primary
sh deploy.sh standby
