#!/bin/bash
set -e

cd ~/bitcoin
git checkout loccs-dev
git reset
git pull origin loccs-dev
make
make install