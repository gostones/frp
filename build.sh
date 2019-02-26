#!/bin/sh

export GOOS=linux
export CGO_ENABLED=0

make clean
make