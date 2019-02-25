#!/bin/bash
set -e

cd ~/bitcoin
git checkout loccs-dev
git pull origin loccs-dev
make
make install