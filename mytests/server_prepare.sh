#!/bin/bash
set -e

BALANCE=`bitcoin-cli -regtest getbalance`
ACCOUNT=`cat /home/ubuntu/account.txt`
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