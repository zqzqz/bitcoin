#! /bin/bash
source $(cd `dirname $0`; pwd)/config

SRC_DIR=${BASE_DIR}"/bitcoin/src"
TEST_DIR=${BASE_DIR}"/bitcoin/mytests"
SERVER_TEST_DIR=${SERVER_DIR}"/bitcoin/mytests"
IP_LIST=`cat ${TEST_DIR}/ip.txt`

for IP in $IP_LIST
do
    ssh ${KEY_CONF} ${USER_NAME}@${IP} "nohup bash ${SERVER_TEST_DIR}/server_gentx.sh > ${SERVER_DIR}/tx_log &" &
    sleep 0.02
    ssh ${KEY_CONF} ${USER_NAME}@${IP} "nohup bash ${SERVER_TEST_DIR}/server_mine.sh > ${SERVER_DIR}/mine_log &" &
    sleep 0.02
done

# wait for all backup process to finish
SSH_FLAG=`ps | grep -c "ssh"`
while [ "$SSH_FLAG" -ne 0 ]
do
    sleep 1
    SSH_FLAG=`ps | grep -c "ssh"`
done

echo "\nComplete!"
