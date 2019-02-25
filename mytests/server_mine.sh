#!/bin/bash

TIME="300"
PERIOD="12"
ERROR=0
LOOP=`python -c "print(int(float($TIME)/float($PERIOD)))"`

for i in {1..$LOOP}
do
    INTERNAL=`python -c "from random import random;print(random()*float($PERIOD))"`
    sleep $INTERNAL
    bitcoin-cli -regtest generate 1
    sleep `python -c "print(float($PERIOD)-float($INTERNAL))"`
done

echo "Quit mining"