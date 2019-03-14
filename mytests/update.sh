#! /bin/bash
source $(cd `dirname $0`; pwd)/config

TEST_DIR=${SERVER_DIR}"/bitcoin/mytests"
IP_LIST=`cat ${TEST_DIR}/ip.txt`

bash ${BASE_DIR}/bitcoin/mytests/server_update.sh

for IP in $IP_LIST
do
    ssh ${KEY_CONF} ${USER_NAME}@${IP} "bash ${TEST_DIR}/server_update.sh" & 
    sleep 0.5
done

# wait for all backup process to finish
SSH_FLAG=`ps | grep -c "ssh"`
while [ "$SSH_FLAG" -ne 0 ]
do
    sleep 1
    SSH_FLAG=`ps | grep -c "ssh"`
done

echo "Complete!"