#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

if [ $# -ge 1 ]; then
    export PROFILE=$1
else
    export PROFILE="dev"
fi

export WORLD_ADDRESS=$(cat ./manifests/$PROFILE/manifest.json | jq -r '.world.address')
export GAME_SYSTEM_ADDRESS=$(cat ./manifests/$PROFILE/manifest.json | jq -r '.contracts[] | select(.name == "starktrip::systems::game_system::game_system" ).address')

echo "---------------------------------------------------------------------------"
echo profile : $PROFILE
echo "---------------------------------------------------------------------------"
echo world : $WORLD_ADDRESS
echo " "
echo game_system : $GAME_SYSTEM_ADDRESS
echo "---------------------------------------------------------------------------"

# enable system -> models authorizations
sozo -P ${PROFILE} auth grant --world $WORLD_ADDRESS --wait writer \
  Game,$GAME_SYSTEM_ADDRESS\
  Board,$GAME_SYSTEM_ADDRESS\
  Tile,$GAME_SYSTEM_ADDRESS\
  CharactersInside,$GAME_SYSTEM_ADDRESS\
  Spaceship,$GAME_SYSTEM_ADDRESS\
  LeaderBoard,$GAME_SYSTEM_ADDRESS\
  LeaderBoardPlayers,$GAME_SYSTEM_ADDRESS
