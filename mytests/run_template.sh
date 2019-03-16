#! /bin/bash
source $(cd `dirname $0`; pwd)/config

NODE_ID=$1
PORT=`expr ${DEFAULT_PORT} + ${NODE_ID}`
RPCPORT=`expr ${DEFAULT_RPCPORT} + ${NODE_ID}`
OPTION="-datadir=${SERVER_DIR}/.bitcoin/regtest${NODE_ID} -port=${PORT} -rpcport=${RPCPORT}"
CMD="bitcoin-cli ${OPTION} $2 $3 $4"
echo "$CMD"
$CMD