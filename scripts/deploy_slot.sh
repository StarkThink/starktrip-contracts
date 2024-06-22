#!/bin/bash

profile="$1"

if [ "$profile" != "prod" ] && [ "$profile" != "testing" ]; then
    echo "Error: Invalid profile. Please use 'prod' or 'testing'."
    exit 1
fi

echo "Deploying Slot in ${profile}."

set -e
if [ -d "target" ]; then
    rm -rf "target"
fi

if [ -d "manifests" ]; then
    rm -rf "manifests"
fi

if [ -d "abis" ]; then
    rm -rf "abis"
fi

slot deployments delete starktrip-${profile} katana
slot deployments delete starktrip-${profile} torii

sleep 2
slot deployments create starktrip-${profile} katana -v v0.6.0 --disable-fee true --invoke-max-steps 4294967295 --seed 420

echo "sozo -P ${profile} build && sozo -P ${profile} migrate apply"
output=$(sozo -P ${profile} build && sozo -P ${profile} migrate apply)
echo "$output"

export world_address=$(cat ./manifests/$profile/manifest.json | jq -r '.world.address')
export config_system_address=$(cat ./manifests/$profile/manifest.json | jq -r '.contracts[] | select(.name == "starktrip::systems::config_system::config_system" ).address')
sozo -P ${profile} execute "${config_system_address}" init --world "$world_address"

./scripts/default_auth.sh ${profile}

echo -e "\n✅ Setup finish!"

echo -e "\n✅ Init Torii!"
slot d create starktrip-${profile} torii --rpc https://api.cartridge.gg/x/starktrip-${profile}/katana --world $world_address -v v0.6.0 --start-block 0
