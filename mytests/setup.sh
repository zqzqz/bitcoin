#! /bin/bash
source $(cd `dirname $0`; pwd)/config

SRC_DIR=${BASE_DIR}"/bitcoin/src"
TEST_DIR=${BASE_DIR}"/bitcoin/mytests"
SERVER_TEST_DIR=${SERVER_DIR}"/bitcoin/mytests"
IP_LIST=$(cat ${TEST_DIR}/ip.txt)
IP_ARRAY=($IP_LIST)

NUM_NEIGHBOR=10

echo "Launching client"

# launch daemon server
for IP in $IP_LIST
do
    ssh ${KEY_CONF} ${USER_NAME}@${IP} "bash ${SERVER_TEST_DIR}/server_setup.sh 2>&1 > ${SERVER_DIR}/setup_log" &
    sleep 0.5
done

# wait for all backup process to finish
SSH_FLAG=`ps | grep -c "ssh"`
while [ "$SSH_FLAG" -ne 0 ]
do
    sleep 1
    SSH_FLAG=`ps | grep -c "ssh"`
done

echo "Configuring accounts"

# configure accounts
for IP in $IP_LIST
do
    ssh ${KEY_CONF} ${USER_NAME}@${IP} "bitcoin-cli -regtest getnewaddress > ${SERVER_DIR}/account.txt" &
    sleep 0.1
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
for IP in $IP_LIST
do
    for i in {1..$NUM_NEIGHBOR}
    do
        RANDOM_INDEX=`python -c "from random import randint;print(randint(0,${!IP_ARRAY[@]}-1))"`
        if [ "${IP_ARRAY[$RANDOM_INDEX]}" == "$IP" ]; then
            continue
        fi
        ssh ${KEY_CONF} ${USER_NAME}@${IP} "bitcoin-cli -regtest addnode ${IP_ARRAY[$RANDOM_INDEX]} onetry" &
        sleep 0.2
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