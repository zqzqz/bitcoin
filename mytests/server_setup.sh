#!/bin/bash
set -e
source $(cd `dirname $0`; pwd)/config

PROCESS_NUM=`ps -e | grep -c "bitcoin"`
echo $PROCESS_NUM
if [ $PROCESS_NUM -ne "0" ]; then
    PIDS=$(ps -e | grep "bitcoin" | awk '{print $1}')
    for PID in $PIDS
    do
        kill $PID
    done
fi

if [ ! -d "${SERVER_DIR}/.bitcoin" ]; then
    mkdir "${SERVER_DIR}/.bitcoin"
fi

NODE_RANGE=`expr $NODE_NUM - 1`

for NODE_ID in $(seq 0 1 $NODE_RANGE)
do
    BITCOIN_DIR=${SERVER_DIR}"/.bitcoin/regtest${NODE_ID}"
    PORT=`expr ${DEFAULT_PORT} + $NODE_ID`
    RPCPORT=`expr ${DEFAULT_RPCPORT} + $NODE_ID`
    OPTIONS="-regtest -datadir=${BITCOIN_DIR} -port=${PORT} -rpcport=${RPCPORT}"
    if [ -d ${BITCOIN_DIR} ]; then
        rm -rf ${BITCOIN_DIR}
    fi
    mkdir ${BITCOIN_DIR}
    printf "rpcuser=USER\nrpcpassword=PASS" > ${BITCOIN_DIR}/bitcoin.conf

    sleep 1
    bitcoind ${OPTIONS} -daemon
    sleep 5
    bitcoin-cli ${OPTIONS} getnewaddress > ${BITCOIN_DIR}/account.txt
    bitcoin-cli ${OPTIONS} getnewaddress > ${BITCOIN_DIR}/account2.txt
done
