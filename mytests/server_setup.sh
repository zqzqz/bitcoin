#!/bin/bash
set -e
source $(cd `dirname $0`; pwd)/config

BITCOIN_DIR=${SERVER_DIR}"/.bitcoin/regtest"

if [ -d ${BITCOIN_DIR} ]; then
    rm -rf ${BITCOIN_DIR}
fi
kill $(ps -e | grep "bitcoin")
bitcoind -regtest -daemon