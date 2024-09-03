# Open Science Platform

This is the repository for the project Open Science, on its final form the project will deliver a sample DApp based on:

- Hyperledger Iroha 1
- Hyperledger Burrow
- Smart contracts
- IPFS

---
## 1 -  Requirements

Docker images:

- new_jupyter_lab (see Dockerfile)

- Iroha 1

- IPFS Kubo

* All containers must be attached to the iroha network.

* Clone the Iroha 1 repo:

```bash
git clone https://github.com/iroha
```


* Create local directories at your docker host:

```bash
mkdir ipfs_repo ipfs_repo/staging ipfs_repo/data
```

  
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


# WIP List

## 3 - New features

3.1 - Improve function `upload_file_to_ipfs` to get the original file name and store it on `file_n_metadata` JSON automatically.

## 4 - Monitoring

Use Prometheus for monitoring basic metrics.

## 5 - Document functions and generate documentation

5.1 - Check functions and maybe breakdown them further for [better maintainability](https://www.linkedin.com/posts/khuyen-tran-1401_productionreadydatascience-datascience-cleancode-activity-7236085519871307776-WLDK/?utm_source=share&utm_medium=member_android)

