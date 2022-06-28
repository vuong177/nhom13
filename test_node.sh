KEY="mykey"
CHAINID="test-1"
MONIKER="localtestnet"
KEYALGO="secp256k1"
KEYRING="test"
LOGLEVEL="info"
# to trace evm
#TRACE="--trace"
TRACE=""

# validate dependencies are installed
command -v jq > /dev/null 2>&1 || { echo >&2 "jq not installed. More info: https://stedolan.github.io/jq/download/"; exit 1; }

# remove existing daemon
rm -rf ~/.craft*

nhom13 config keyring-backend $KEYRING
nhom13 config chain-id $CHAINID

# if $KEY exists it should be deleted
# decorate bright ozone fork gallery riot bus exhaust worth way bone indoor calm squirrel merry zero scheme cotton until shop any excess stage laundry
echo "decorate bright ozone fork gallery riot bus exhaust worth way bone indoor calm squirrel merry zero scheme cotton until shop any excess stage laundry"
nhom13 keys add $KEY --keyring-backend $KEYRING --algo $KEYALGO --recover
# Set moniker and chain-id for Evmos (Moniker can be anything, chain-id must be an integer)
nhom13 init $MONIKER --chain-id $CHAINID 

# Set gas limit in genesis
cat $HOME/.nhom13/config/genesis.json | jq '.consensus_params["block"]["max_gas"]="100000000"' > $HOME/.nhom13/config/tmp_genesis.json && mv $HOME/.nhom13/config/tmp_genesis.json $HOME/.nhom13/config/genesis.json
cat $HOME/.nhom13/config/genesis.json | jq '.app_state["gov"]["voting_params"]["voting_period"]="15s"' > $HOME/.nhom13/config/tmp_genesis.json && mv $HOME/.nhom13/config/tmp_genesis.json $HOME/.nhom13/config/genesis.json

# Allocate genesis accounts (cosmos formatted addresses)
nhom13 add-genesis-account $KEY 100000000000000000000000000stake,10000000000token --keyring-backend $KEYRING

# Sign genesis transaction
nhom13 gentx $KEY 1000000000000000000000stake --keyring-backend $KEYRING --chain-id $CHAINID

# Collect genesis tx
nhom13 collect-gentxs

# Run this to ensure everything worked and that the genesis file is setup correctly
nhom13 validate-genesis

if [[ $1 == "pending" ]]; then
  echo "pending mode is on, please wait for the first block committed."
fi

# # Start the node (remove the --pruning=nothing flag if historical queries are not needed)
nhom13 start --pruning=nothing  --minimum-gas-prices=0.0001stake         
