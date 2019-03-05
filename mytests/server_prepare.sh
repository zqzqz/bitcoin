#!/bin/bash
set -e
source $(cd `dirname $0`; pwd)/config

BALANCE=`bitcoin-cli -regtest getbalance`
ACCOUNT=`cat ${SERVER_DIR}/account.txt`
MAX_TRY=2000

while [ "$BALANCE" -eq 0 ]
do
    bitcoin-cli -regtest generate 1
    MAX_TRY="$MAX_TRY"-1
    if [ "$MAX_TRY" -le 0 ]; then
        break
    fi
done

echo ${ACCOUNT}" done"