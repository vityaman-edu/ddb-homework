#!/bin/sh

cd "$(dirname "$0")" && cd ..

CONTAINER_ID="$(docker inspect -f '{{.Id}}' ddb-$1)"
echo "Deploy for container $1"

docker cp ./db/$1 $CONTAINER_ID:/home/postgres0/$1
