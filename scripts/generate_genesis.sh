#!/bin/bash

chain_id=$1
new_dir=$3
moniker_name=validator
# COIN="10000000000000unub"
file=$2

# If the directory isn't here then create it
if [ ! -d "$new_dir" ]; then
  mkdir -p $new_dir
fi

if [ ! -d "$chain_id/genesis" ]; then
  mkdir -p $chain_id/genesis
fi


# Create the new node
nubit-validatord --home=$new_dir init $moniker_name --chain-id $chain_id

# nubit-validatord --home=$new_dir keys add $new_node_name --keyring-backend=test
# node_addr=$(nubit-validatord --home=$new_dir keys show $new_node_name -a --keyring-backend test)

## Add the genesis accounts
while read -r line; do
    echo -e "read: $line\n"
    node_addr=$(echo "$line" | cut -d ',' -f 1)
    COIN=$(echo "$line" | cut -d ',' -f 2)
    nubit-validatord --home=$new_dir add-genesis-account $node_addr $COIN --keyring-backend test 
done <$file

# celestia-appd start --rpc.laddr tcp://0.0.0.0:26657

# Copy the new node's config to the original node
# cp $new_dir/config/gentx/gentx-*.json $dest_dir/config/gentx/

# Collect gentxs on original node
# nubit-validatord --home=$dest_dir collect-gentxs

# Copy the information from the original node's genesis to the new node
# cp -r $dest_dir/config/gentx/ $new_dir/config/gentx

# Copy the original node's updated genesis.json
cp $new_dir/config/genesis.json $chain_id/genesis/genesis.json

# delete the new_dir
rm -rf $new_dir