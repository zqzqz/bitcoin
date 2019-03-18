# TEST Environment Documentation

The test environment consists of one control server and multiple peer servers. Each peer server runs multiple bitcoin nodes.  
Scripts locate at directory `mytests`

## Preparation

* First, write the list of IPs into `ip.txt` like

```
10.1.4.11
10.1.4.12
10.1.4.13
```

* Second, configure your own test by modifying `config` like (only list some important configurations here)

```bash
# number of nodes on each server
NODE_NUM="2"
# number of neighbors each node has
NEIGHBOR_NUM="10"
# the total time length (sec) of generating transactions, usually the same as MINE_TIME
TX_TIME="10"
# the period (sec) of generating transactions
TX_PERIOD="0.5"
# the total time length (sec) of generating blocks, usually the same as TX_TIME
MINE_TIME="10"
# the period (sec) of generating blocks
MINE_PERIOD="1"
```

* Process your own bitcoin code. See configures in `src/primitives/block.h`

```cpp
#define POWER_CRITICAL 16 // ratio of the number of critical blocks and normal blocks
#define NUM_TX_SHARD 7 // if the transaction pool is sliced to X pieces, NUM_TX_SHARD=X-1
#define NUM_REF 4 // number of extra references for each block
```

You can use cmake options to load these configures instead of modifying source files. But I did not do that.. **TBD**

## Install build environment for each server

* Run `bash configure.sh` on the control server.  
This script will execute `server_configure.sh` on each peer server, download dependencies, clone this repo and build the binary.  
**NOTICE** For convenience, the script contains commands with `sudo`, so you must configure your server to forbid asking password when using `sudo`.  

* Run `bash update.sh` to update all servers to latest head of this repo, if necessary.  
The script simply hardly reset any modifications, pull newest `loccs-dev` branch and rebuild the code.  

## Setup bitcoin network

* Run `bash setup.sh`  
In the first step, the script executes `server_setup.sh`, which configures regtest nodes, runs `bitcoind` daemon and setup two accounts for each node.  
Later in the second step, the script randomly connects the nodes with others by `bitcoin-cli addnode` command.  

## Run the test

* Run `bash start.sh`  
Given configuration in `config`, all nodes will start generating transactions and blocks periodically.  
**NOTICE** The nodes will not send out any transaction when their balance is zero. The reward of mined blocks is avaiable after 1 block.

* See results using `bitcoin-cli getblockchaininfo`  
Also, you can edit `getblockchaininfo` in `src/rpc/blockchain.cpp` to customize your reports  


## Other notes

* Any code modification follows a comment `edit`. Use `grep -r -n "// edit"` to see where I have changed.  

* Add option `-debug=1` for `bitcoind` to see full logs. My customized logs start with `TEST:`.