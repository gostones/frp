#!/bin/sh

docker create -ti --name dummy asperitus/frp sh
docker cp dummy:/app ./build
docker rm -fv dummy