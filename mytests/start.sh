#! /bin/bash

SRC_DIR="/home/zqz/Documents/bitcoin/src"
TEST_DIR="/home/zqz/Documents/bitcoin/mytests"
SERVER_DIR="/home/ubuntu/bitcoin/mytests"
IP_LIST=`cat ${TEST_DIR}/ip.txt`

KEY_CONF="-i ~/.ssh/ubuntu2.pem"
USER_NAME="ubuntu"

for IP in $IP_LIST
do
    ssh ${KEY_CONF} ${USER_NAME}@${IP} "nohup bash ${SERVER_DIR}/server_gentx.sh > /home/ubuntu/tx_log &" &
    sleep 0.02
    ssh ${KEY_CONF} ${USER_NAME}@${IP} "nohup bash ${SERVER_DIR}/server_mine.sh > /home/ubuntu/mine_log &" &
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