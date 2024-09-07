# Open Science Platform

This is the repository for the project Open Science, on its final form the project will deliver a sample DApp based on:

- Hyperledger Iroha 1
- Hyperledger Burrow
- Smart contracts
- IPFS

---

General Overview

Iroha 1 Python SDK

This notebook uses [Iroha 1 Python Library ](https://pypi.org/project/iroha/)


Smart Contracts

The integration of smart contracts into Iroha 1 is executed by Hyperledger Burrow. For additional information refer to [Iroha Smart Contracts Integration](https://iroha.readthedocs.io/en/develop/integrations/burrow.html?highlight=contract). Use this docker image `hyperledger/iroha-burrow:pr-3960`, see below.


IPFS

This project uses [Python IPFS HTTP Client](https://github.com/ipfs-shipyard/py-ipfs-http-client)



---
## 1 -  Requirements

Docker images:

- new_jupyter_lab (see Dockerfile)

- Iroha 1

- [IPFS Kubo](https://blog.ipfs.tech/1-run-ipfs-on-docker/) 

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


2.1 - Jupyter Notebooks

```bash
docker run -it -p 10.0.0.100:10000:8888 --network=iroha-network new_jupyter_lab
```

2.2 IPFS Node

```bash
docker run -d --name ipfs_node -v ~/ipfs_repo/staging:/export -v ~/ipfs_repo/data:/data/ipfs -p 4001:4001 -p 8080:8080 -p 5001:5001 --network iroha-network ipfs/go-ipfs:v0.4.23
```

2.3 Iroha Network

```bash
docker run --name iroha -d -p 50051:50051 -p 7001:7001 -v $(pwd)/iroha/example:/opt/iroha_data -v blockstore:/tmp/block_store --network=iroha-network --restart always -e KEY='node0' hyperledger/iroha-burrow:pr-3960
```

2.4 - IP Address and related connections parameters

For iroha and IPFS, check and edit `config.json` according to the networking settings for your environment.


2.5 - Caveats and Workarounds

2.5.1  - Genesis Block

The default Genesis block for Iroha 1 docker image `admin@test` does not have the proper permission to creat smart contracts, therefore it is necessary to add the permission for the `admin@test` account editing the `genesis.block`file as instructed below.


### How to run a specific genesis-block, to add/change permissions

- The genesis block file is read from the local iroha/example/genesis_block file. 

- This is the modified block, with the admin role permission set root.

- After that you only need to execute docker run with the proper parameters of the iroha container.

```genesis_block
                       {
                          "createRole":{
                             "roleName":"admin",
                             "permissions":[
                                "root"                             
                             ]
                          }
                       },

```




# WIP List

## 3 - New features

3.1 - Improve function `upload_file_to_ipfs` to get the original file name and store it on `file_n_metadata` JSON automatically.

## 4 - Monitoring

Use Prometheus for monitoring basic metrics.

## 5 - Document functions and generate documentation

5.1 - Check functions and maybe breakdown them further for [better maintainability](https://www.linkedin.com/posts/khuyen-tran-1401_productionreadydatascience-datascience-cleancode-activity-7236085519871307776-WLDK/?utm_source=share&utm_medium=member_android)

