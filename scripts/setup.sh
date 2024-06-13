#!/bin/bash

set -e
if [ -d "target" ]; then
    rm -rf "target"
fi

if [ -d "manifests" ]; then
    rm -rf "manifests"
fi

echo "sozo build && sozo migrate apply"
output=$(sozo build && sozo migrate apply)

# Definir el color cyan
cyan='\033[0;36m'
# Resetear el color
reset='\033[0m'

# Init systems
INITIABLE_SYSTEMS=("config_system")
world_address=$(echo "$output" | awk '/Successfully migrated World on block #3 at address/ {print $NF}')

# Store system names and addresses in a string
system_address_list=""

while read -r line; do
  if [[ $line =~ "Contract address:" ]]; then
    system_name=$(echo "$last_line" | awk -F'::' '{print $NF}')  # Get last field after "::"
    address=$(echo "$line" | awk '{print $NF}')                # Get last field (address)
    
    if [ "$system_name" = "# World" ]; then
      system_name="world"
    fi

    # Append system name and address as a pair to the list
    system_address_list+="$system_name:$address;"
  else
    last_line=$line
  fi
done <<< "$output"

get_address() {
    system_name=$1
    address=$(echo "$system_address_list" | grep -o "$system_name:[^;]*" | cut -d ':' -f 2)
    echo "$address"
}

echo "sozo migrate apply: $output"

# Set system addresses
for system_name in $(echo "$system_address_list" | awk -F';' '{for(i=1;i<=NF;i++){split($i, arr, ":"); print arr[1]}}' | sort -u); do
  address_variable="${system_name}_address"
  address=$(get_address "$system_name")
  declare "$address_variable"="$address"
done

echo -e "\n✅ Systems addresses"

# Print system addresses
for system_name in $(echo "$system_address_list" | awk -F';' '{for(i=1;i<=NF;i++){split($i, arr, ":"); print arr[1]}}' | sort -u); do
  address_variable="${system_name}_address"
  echo -e "${cyan}   ▶️ ${system_name}: ${!address_variable}${reset}"
done

echo -e "\n✅ Setup"

for system_name in "${INITIABLE_SYSTEMS[@]}"; do
  address_variable="${system_name}_address"
  if [ -n "${!address_variable}" ]; then
    sozo execute "${!address_variable}" init --world "$world_address"
    sleep 3
  else
    echo "Address not found for $system_name. Skipping initialization."
  fi
done

./scripts/default_auth.sh

echo -e "\n✅ Setup finish!"
world_address=$(get_address "world")

echo -e "\n✅ Init Torii!"
torii --world $world_address