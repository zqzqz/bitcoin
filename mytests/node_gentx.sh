#!/bin/bash
source $(cd `dirname $0`; pwd)/config

NODE_ID=$1
PORT=`expr ${DEFAULT_PORT} + $NODE_ID`
RPCPORT=`expr ${DEFAULT_RPCPORT} + $NODE_ID`
OPTIONS="-regtest -datadir=${SERVER_DIR}/.bitcoin/regtest${NODE_ID} -port=${PORT} -rpcport=${RPCPORT}"
ERROR=0
LOOP=`python3 -c "print(int(float($TX_TIME)/float($TX_PERIOD)))"`

ACCOUNT=`cat ${SERVER_DIR}/.bitcoin/regtest${NODE_ID}/account.txt`
ACCOUNT2=`cat ${SERVER_DIR}/.bitcoin/regtest${NODE_ID}/account2.txt`

BALANCE=`bitcoin-cli ${OPTIONS} getbalance`
for i in $(seq 1 1 $LOOP)
do
    if [ $BALANCE -gt "0" ]; then
        INTERNAL=`python3 -c "from random import random;print(random()*float($TX_PERIOD))"`
        sleep $INTERNAL
        FLAG=$(($i % 2))
        if [ $FLAG -eq 1 ]; then
            bitcoin-cli -regtest sendfrom $ACCOUNT $ACCOUNT2 0.0001
        else
            bitcoin-cli -regtest sendfrom $ACCOUNT2 $ACCOUNT 0.0001
        fi
        sleep `python3 -c "print(float($TX_PERIOD)-float($INTERNAL))"`
    else
        sleep $TX_PERIOD
    fi
done

echo "Quit transaction generating"