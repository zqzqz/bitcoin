#!/bin/bash

TIME="300"
PERIOD="0.2"
ERROR=0
LOOP=`python -c "print(int(float($TIME)/float($PERIOD)))"`

ACCOUNT=`cat /home/ubuntu/account.txt`
ACCOUNT2=`bitcoin-cli -regtest getnewaddress`

for i in {1..$LOOP}
do
    INTERNAL=`python -c "from random import random;print(random()*float($PERIOD))"`
    sleep $INTERNAL
    FLAG=$(($i % 2))
    if [ $FLAG -eq 1 ]; then
        bitcoin-cli -regtest sendfrom $ACCOUNT $ACCOUNT2 0.001
    else
        bitcoin-cli -regtest sendfrom $ACCOUNT2 $ACCOUNT 0.001
    fi
    sleep `python -c "print(float($PERIOD)-float($INTERNAL))"`
done

echo "Quit transaction generating"