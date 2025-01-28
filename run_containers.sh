#!/bin/bash

# Define the base directory
BASE_DIR="/home/eduardo/Documents/repo/Git"

# Function to wait for a container to be up and running
wait_for_container() {
  local container_name=$1
  echo "Waiting for container $container_name to start..."
  while true; do
    status=$(docker inspect --format='{{.State.Running}}' "$container_name" 2>/dev/null)
    if [[ "$status" == "true" ]]; then
      echo "Container $container_name is running."
      break
    fi
    sleep 2
  done
}

# Navigate to the repository directory
cd "$BASE_DIR" || { echo "Directory $BASE_DIR not found. Exiting."; exit 1; }

# Clean up unused Docker resources
docker system prune -f

# Create the Docker network if it doesn't already exist
docker network inspect iroha-network >/dev/null 2>&1 || docker network create iroha-network

# Run the PostgreSQL container
docker run --name some-postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -p 5432:5432 \
  --network=iroha-network \
  -d \
  postgres:9.5 \
  -c 'max_prepared_transactions=100'
wait_for_container "some-postgres"

# Ensure PostgreSQL is running and navigate to the required directory
if docker inspect --format='{{.State.Running}}' some-postgres | grep -q "true"; then
  cd "$BASE_DIR" || { echo "Failed to navigate to $BASE_DIR for Iroha. Exiting."; exit 1; }
else
  echo "PostgreSQL container is not running. Exiting."
  exit 1
fi

# Run the Hyperledger Iroha container
docker run --name iroha \
  -d \
  -p 50051:50051 \
  -p 7001:7001 \
  -v "$(pwd)/iroha/example:/opt/iroha_data" \
  -v blockstore:/tmp/block_store \
  --network=iroha-network \
  -e KEY='node0' \
  hyperledger/iroha-burrow:pr-3960
wait_for_container "iroha"

# Run the IPFS container
docker run --name ipfs_node \
  -d \
  -v ~/ipfs_repo/staging:/export \
  -v ~/ipfs_repo/data:/data/ipfs \
  --restart unless-stopped \
  -p 4001:4001 \
  -p 8080:8080 \
  -p 5001:5001 \
  --network=iroha-network \
  ipfs/go-ipfs:v0.4.23
wait_for_container "ipfs_node"

# Run the JupyterLab container
docker run --name jupyter_lab \
  -d \
  -p 10000:8888 \
  --network=iroha-network \
  new_jupyter_lab
wait_for_container "jupyter_lab"
