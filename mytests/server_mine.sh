#!/bin/bash
source $(cd `dirname $0`; pwd)/config

NODE_RANGE=`expr $NODE_NUM - 1`
for NODE_ID in $(seq 0 1 $NODE_RANGE)
do
    bash ${SERVER_DIR}/bitcoin/mytest/node_mine.sh $NODE_ID &
done