# Open Science Platform

This is the repository for the project Open Science, on its final form the project will deliver a sample DApp based on:

- Hyperledger Iroha 1
- Hyperledger Burrow
- Smart contracts
- IPFS
- Flask.

---
## 1 -  Requirements

Docker images:

- new_jupyter_lab (see Dockerfile)

- iroha

- IPFS Kubo

* All container must be attached to the iroha network
  
## 2 - Setup


Jupyter Notebooks

```bash
docker run -it -p 10.0.0.100:10000:8888 --network=iroha-network new_jupyter_lab
```

IPFS Node

```bash
docker run -d --name ipfs_node -v ~/ipfs_repo/staging:/export -v ~/ipfs_repo/data:/data/ipfs -p 4001:4001 -p 8080:8080 -p 5001:5001 --network iroha-network ipfs/go-ipfs:v0.4.23
```

Iroha Network

```bash
docker run --name iroha -d -p 50051:50051 -p 7001:7001 -v $(pwd)/iroha/example:/opt/iroha_data -v blockstore:/tmp/block_store --network=iroha-network --restart always -e KEY='node0' hyperledger/iroha-burrow:pr-3960
```
