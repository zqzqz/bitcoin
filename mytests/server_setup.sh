#!/bin/bash
set -e

BITCOIN_DIR="/home/ubuntu/.bitcoin/regtest"
SERVER_DIR="/home/ubuntu"
if [ -d ${BITCOIN_DIR} ]; then
    rm -rf ${BITCOIN_DIR}
fi
kill $(ps -e | grep "bitcoin")
bitcoind -regtest -daemon