#!/bin/bash
set -e
source $(cd `dirname $0`; pwd)/config

kill $(ps -e | grep "bitcoin")

NODE_RANGE=`expr $NODE_NUM - 1`
for NODE_ID in {0..$NODE_RANGE}
do
    BITCOIN_DIR=${SERVER_DIR}"/.bitcoin/regtest${NODE_ID}"
    PORT=`expr ${DEFAULT_PORT} + $NODE_ID`
    OPTIONS="-regtest -datadir=${BITCOIN_DIR} -rpcport=${PORT}"
    if [ -d ${BITCOIN_DIR} ]; then
        rm -rf ${BITCOIN_DIR}
    fi

    bitcoind ${OPTIONS} -daemon
    sleep 0.5
    bitcoin-cli ${OPTIONS} getnewaddress > ${BITCOIN_DIR}/account.txt
    bitcoin-cli ${OPTIONS} getnewaddress > ${BITCOIN_DIR}/account2.txt
done