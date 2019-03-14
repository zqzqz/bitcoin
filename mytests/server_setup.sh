#!/bin/bash
set -e
source $(cd `dirname $0`; pwd)/config

PROCESS_NUM=`ps -e | grep -c "bitcoin"`
echo $PROCESS_NUM
if [ $PROCESS_NUM -ne "0" ]; then
    echo `ps -e | grep "bitcoin" | awk '{print $1}'`
    kill `ps -e | grep "bitcoin" | awk '{print $1}'`
fi

NODE_RANGE=`expr $NODE_NUM - 1`
for NODE_ID in $(seq 0 1 $NODE_RANGE)
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
