REGTEST="-regtest"

BITCOIND_BIN="/home/zqz/Documents/bitcoin/src/bitcoind "$REGTEST
BITCOIN_CLI_BIN="/home/zqz/Documents/bitcoin/src/bitcoin-cli "$REGTEST

# BITCOIND_BIN="/home/zqz/Documents/bitcoin0/src/bitcoind "$REGTEST
# BITCOIN_CLI_BIN="/home/zqz/Documents/bitcoin0/src/bitcoin-cli "$REGTEST

# $BITCOIND_BIN -daemon
# sleep 3
# $BITCOIN_CLI_BIN generate 2000
# ADDR=`$BITCOIN_CLI_BIN getnewaddress`
# echo "Addr "$ADDR
# TX=`$BITCOIN_CLI_BIN sendtoaddress $ADDR 0.1`
# echo "Tx "$TX

for i in $(seq 1 1)
do
    BLOCK=`$BITCOIN_CLI_BIN generate 1 | jq .[0] | sed 's/\"//g'`
    $BITCOIN_CLI_BIN getblock $BLOCK
done

$BITCOIN_CLI_BIN getblockchaininfo