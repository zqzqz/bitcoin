#!/bin/bash

NODE_ID=$1
PORT=`expr ${DEFAULT_PORT} + $NODE_ID`
OPTIONS="-regtest -datadir=${SERVER_DIR}/.bitcoin/regtest${NODE_ID} -rpcport=${PORT}"
ERROR=0
LOOP=`python -c "print(int(float($MINE_TIME)/float($MINE_PERIOD)))"`

for i in {1..$LOOP}
do
    INTERNAL=`python -c "from random import random;print(random()*float($MINE_PERIOD))"`
    sleep $INTERNAL
    bitcoin-cli ${OPTIONS} generate 1
    sleep `python -c "print(float($MINE_PERIOD)-float($INTERNAL))"`
done

echo "Quit mining"