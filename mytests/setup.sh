#! /bin/bash
source $(cd `dirname $0`; pwd)/config

SRC_DIR=${BASE_DIR}"/bitcoin/src"
TEST_DIR=${BASE_DIR}"/bitcoin/mytests"
SERVER_TEST_DIR=${SERVER_DIR}"/bitcoin/mytests"
IP_LIST=`cat ${TEST_DIR}/ip.txt`
IP_ARRAY=($IP_LIST)

NUM_NEIGHBOR=10

echo "Launching client"

# launch daemon server
for IP in $IP_LIST
do
    ssh ${KEY_CONF} ${USER_NAME}@${IP} "bash ${SERVER_TEST_DIR}/server_setup.sh > ${SERVER_DIR}/setup_log" &
done

# wait for all backup process to finish
SSH_FLAG=`ps | grep -c "ssh"`
while [ "$SSH_FLAG" -ne 0 ]
do
    sleep 1
    SSH_FLAG=`ps | grep -c "ssh"`
done

echo "Configuring network"

# configure network
POINT_NUM=`expr ${#IP_ARRAY[@]} \* ${NODE_NUM}`
POINT_RANGE=`expr ${POINT_NUM} - 1`

for POINT in $(seq 0 1 $POINT_RANGE)
do
    CUR_IP_INDEX=`expr $POINT / ${NODE_NUM}`
    CUR_NODE_INDEX=`expr $POINT % ${NODE_NUM}`
    for i in $(seq 0 1 $NEIGHBOR_NUM)
    do
        RANDOM_INDEX=`python -c "from random import randint;print(randint(0,${#IP_ARRAY[@]}*${NODE_NUM}-1))"`
        IP_INDEX=`expr $RANDOM_INDEX / ${NODE_NUM}`
        NODE_INDEX=`expr $RANDOM_INDEX % ${NODE_NUM}`
        if [ "$IP_INDEX" -eq "$CUR_IP_INDEX" -a "$NODE_INDEX" -eq "$CUR_NODE_INDEX" ]; then
            continue
        fi
        CUR_PORT=`expr ${DEFAULT_PORT} + ${CUR_NODE_INDEX}`
        CUR_RPCPORT=`expr ${DEFAULT_RPCPORT} + ${CUR_NODE_INDEX}`
        PORT=`expr ${DEFAULT_PORT} + ${NODE_INDEX}`
        RPCPORT=`expr ${DEFAULT_RPCPORT} + ${NODE_INDEX}`
        OPTIONS="-regtest -datadir=${SERVER_DIR}/.bitcoin/regtest${NODE_ID} -port=${CUR_PORT} -rpcport=${CUR_RPCPORT}"
        echo "connecting "${IP_ARRAY[$CUR_IP_INDEX]}:${CUR_PORT}" to "${IP_ARRAY[$IP_INDEX]}:${PORT}
        ssh ${KEY_CONF} ${USER_NAME}@${IP_ARRAY[$CUR_IP_INDEX]} "bitcoin-cli ${OPTIONS} addnode ${IP_ARRAY[$IP_INDEX]}:${PORT} onetry &"
    done
done

# wait for all backup process to finish
SSH_FLAG=`ps | grep -c "ssh"`
while [ "$SSH_FLAG" -ne 0 ]
do
    sleep 1
    SSH_FLAG=`ps | grep -c "ssh"`
done

echo "Complete!"
