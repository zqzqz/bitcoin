#!/bin/bash
set -e

cd ~/bitcoin
git checkout loccs-dev
git reset --hard origin/loccs-dev
git pull origin loccs-dev
make
sudo make install