#!/bin/bash
set -e
source $(cd `dirname $0`; pwd)/config

sudo apt-get update
sudo apt-get -y install git
sudo apt-get -y install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3
sudo apt-get -y install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
sudo apt-get -y install software-properties-common
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get -y install libdb4.8-dev libdb4.8++-dev

cd ${SERVER_DIR}
if [ ! -d ${SERVER_DIR}"/bitcoin" ]; then
    git clone https://github.com/zqzqz/bitcoin.git
fi

while [ ! -d ${SERVER_DIR}"/bitcoin" ]
do
    sleep 2
done

cd ${SERVER_DIR}/bitcoin
git checkout loccs-dev
./autogen.sh
./configure --without-gui
make clean
make
sudo make install
