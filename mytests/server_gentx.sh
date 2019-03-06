#!/bin/bash
source $(cd `dirname $0`; pwd)/config

NODE_RANGE=`expr $NODE_NUM - 1`
for NODE_ID in {1..$NODE_RANGE}
do
    bash ${SERVER_DIR}/bitcoin/mytest/node_gentx.sh &
    sleep 0.02 
done